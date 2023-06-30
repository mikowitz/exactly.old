defmodule Exactly.Lilypond.FileTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias Exactly.{Book, Bookpart, Container, Header, Note, Pitch, Score, Voice}
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

    test "saves a file with a top-level bookpart" do
      bookpart = Bookpart.new([Score.new([Note.new()])])

      file =
        LilypondFile.from(bookpart)
        |> LilypondFile.save()

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               \\bookpart {
                 \\score {
                   <<
                     c4
                   >>
                 }
               }
               """)
    end

    test "saves a file with a top-level book" do
      book = Book.new([Bookpart.new([Score.new([Note.new()])])])

      file =
        LilypondFile.from(book)
        |> LilypondFile.save()

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               \\book {
                 \\bookpart {
                   \\score {
                     <<
                       c4
                     >>
                   }
                 }
               }
               """)
    end

    test "saves a file with multiple top-level books" do
      book1 = Book.new([Bookpart.new([Score.new([Note.new()])])])
      book2 = Book.new([Bookpart.new([Score.new([Note.new(Pitch.new(1))])])])

      file =
        LilypondFile.from([book1, book2])
        |> LilypondFile.save()

      assert File.read!(file.source_path) ==
               String.trim("""
               \\version "#{Exactly.lilypond_version()}"
               \\language "english"

               \\book {
                 \\bookpart {
                   \\score {
                     <<
                       c4
                     >>
                   }
                 }
               }

               \\book {
                 \\bookpart {
                   \\score {
                     <<
                       d4
                     >>
                   }
                 }
               }
               """)
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

  describe "compiling using lilypond" do
    @describetag :lilypond

    test "saves multiple books to the default numbered locations" do
      book1 = Book.new([Score.new([Note.new()])])
      book2 = Book.new([Score.new([Note.new()])])

      file =
        LilypondFile.from([book1, book2])
        |> LilypondFile.save("books.ly")

      output_path = Path.rootname(file.source_path)

      [
        Exactly.lilypond_executable(),
        "-o",
        output_path,
        file.source_path
      ]
      |> compile()

      assert_files_exist(["./books.ly", "./books.pdf", "./books-1.pdf"])
    end

    test "saves multiple books with provided suffixes" do
      book1 = Book.new([Score.new([Note.new()])], output_suffix: "test")
      book2 = Book.new([Score.new([Note.new()])], output_suffix: "example")

      file =
        LilypondFile.from([book1, book2])
        |> LilypondFile.save("books.ly")

      output_path = Path.rootname(file.source_path)

      [
        Exactly.lilypond_executable(),
        "-o",
        output_path,
        file.source_path
      ]
      |> compile()

      assert_files_exist(["./books.ly", "./books-test.pdf", "./books-example.pdf"])
    end

    test "saves multiple books with provided names" do
      book1 = Book.new([Score.new([Note.new()])], output_name: "test")
      book2 = Book.new([Score.new([Note.new()])], output_name: "example")

      file =
        LilypondFile.from([book1, book2])
        |> LilypondFile.save("books.ly")

      output_path = Path.rootname(file.source_path)

      [
        Exactly.lilypond_executable(),
        "-o",
        output_path,
        file.source_path
      ]
      |> compile()

      assert_files_exist(["./books.ly", "./test.pdf", "./example.pdf"])
    end

    test "saves multiple books with provided names + suffixes" do
      book1 = Book.new([Score.new([Note.new()])], output_suffix: "my-test", output_name: "test")

      book2 =
        Book.new([Score.new([Note.new()])], output_suffix: "your-test", output_name: "example")

      file =
        LilypondFile.from([book1, book2])
        |> LilypondFile.save("books.ly")

      output_path = Path.rootname(file.source_path)

      [
        Exactly.lilypond_executable(),
        "-o",
        output_path,
        file.source_path
      ]
      |> compile()

      assert_files_exist(["./books.ly", "./test-my-test.pdf", "./example-your-test.pdf"])
    end
  end

  defp assert_files_exist(files) when is_list(files) do
    for file <- files do
      assert File.exists?(file)
      :ok = File.rm(file)
    end
  end

  defp compile(cmd) do
    cmd
    |> Enum.join(" ")
    |> to_charlist()
    |> :os.cmd()
  end
end
