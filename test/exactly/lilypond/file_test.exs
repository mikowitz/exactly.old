defmodule Exactly.Lilypond.FileTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias Exactly.{Container, Header, Note, Score, Voice}
  alias Exactly.Lilypond.File, as: LilypondFile

  describe "from/1" do
    test "wraps a non-context element in a basic container" do
      note = Note.new()
      file = LilypondFile.from(note)

      assert is_struct(file.content, Container)
    end

    test "does not wrap context elements" do
      voice =
        Voice.new([
          Note.new()
        ])

      file = LilypondFile.from(voice)

      assert is_struct(file.content, Voice)
    end

    test "can take a list of score elements" do
      score = Score.new([Note.new()])

      file = LilypondFile.from([score, Note.new()])

      assert is_list(file.content)

      assert is_struct(Enum.at(file.content, 0), Score)
      assert is_struct(Enum.at(file.content, 1), Container)
    end
  end

  describe "save/1" do
    test "saves the file to a predefined temp directory" do
      file = LilypondFile.from(Note.new())

      file = LilypondFile.save(file)

      assert String.match?(file.source_path, Regex.compile!(Path.expand("~/.exactly")))

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               {
                 c4
               }
               """)

      :ok = File.rm(file.source_path)
    end

    test "saves a file correctly with a header" do
      file = LilypondFile.from(Note.new())

      file =
        file
        |> LilypondFile.set_header(Header.new(tagline: false, title: "Exactly Example"))
        |> LilypondFile.save()

      assert String.match?(file.source_path, Regex.compile!(Path.expand("~/.exactly")))

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               \\header {
                 tagline = ##f
                 title = "Exactly Example"
               }

               {
                 c4
               }
               """)

      :ok = File.rm(file.source_path)
    end

    test "saves a file with multiple top-level contexts" do
      score = Score.new([Note.new()])

      file =
        LilypondFile.from([score, Note.new()])
        |> LilypondFile.save()

      assert String.match?(file.source_path, Regex.compile!(Path.expand("~/.exactly")))

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               \\score {
                 <<
                   c4
                 >>
               }

               {
                 c4
               }
               """)

      :ok = File.rm(file.source_path)
    end

    test "saves the file to specified location" do
      file = LilypondFile.from(Note.new())

      file = LilypondFile.save(file, "location.ly")

      assert file.source_path == Path.join(Path.expand("."), "location.ly")

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               {
                 c4
               }
               """)

      :ok = File.rm(file.source_path)
    end
  end

  describe "compile/1" do
    test "correctly runs the compilation code" do
      file = LilypondFile.from(Note.new())

      output =
        capture_io(fn ->
          file
          |> LilypondFile.save()
          |> LilypondFile.compile()
        end)

      assert Regex.match?(
               ~r/#{Exactly.lilypond_executable()} -s -o (.*) \1\.ly/,
               output
             )
    end
  end
end
