defmodule Exactly.VoiceTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Note, Pitch, Rest, Voice}

  describe "new/1" do
    test "takes a list of containable elements" do
      voice =
        Voice.new([
          Note.new(Pitch.new(), Duration.new(1 / 4)),
          Rest.new(Duration.new(1 / 2)),
          Note.new(Pitch.new(1), Duration.new(1 / 4))
        ])

      assert length(voice.elements) == 3
      assert voice.name == nil
      refute voice.simultaneous
    end
  end

  describe "new/2" do
    test "can take an optional name" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ],
          "VoiceOne"
        )

      assert length(voice.elements) == 3
      assert voice.name == "VoiceOne"
      refute voice.simultaneous
    end
  end

  describe "new/3" do
    test "can set simultaneous via keyword opts" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ],
          "VoiceOne",
          simultaneous: true
        )

      assert length(voice.elements) == 3
      assert voice.name == "VoiceOne"
      assert voice.simultaneous
    end

    test "must set nil name explicitly if using opts" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ],
          nil,
          simultaneous: true
        )

      assert length(voice.elements) == 3
      assert is_nil(voice.name)
      assert voice.simultaneous
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation for an unnamed voice" do
      voice =
        Voice.new([
          Note.new(Pitch.new(), Duration.new(1 / 4)),
          Rest.new(Duration.new(1 / 2)),
          Note.new(Pitch.new(1), Duration.new(1 / 4))
        ])

      assert inspect(voice) == "#Exactly.Voice<{ 3 }>"
    end

    test "for a named voice" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ],
          "ViolinOne"
        )

      assert inspect(voice) == "#Exactly.Voice<ViolinOne { 3 }>"
    end

    test "for a simultaneous voice" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ],
          "ViolinOne",
          simultaneous: true
        )

      assert inspect(voice) == "#Exactly.Voice<ViolinOne << 3 >>>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for an unnamed voice" do
      voice =
        Voice.new([
          Note.new(Pitch.new(), Duration.new(1 / 4)),
          Rest.new(Duration.new(1 / 2)),
          Note.new(Pitch.new(1), Duration.new(1 / 4))
        ])

      assert Exactly.to_lilypond(voice) ==
               String.trim("""
               \\context Voice {
                 c4
                 r2
                 d4
               }
               """)
    end

    test "for a named voice" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(3), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(5), Duration.new(1 / 4))
          ],
          "ViolinOne"
        )

      assert Exactly.to_lilypond(voice) ==
               String.trim("""
               \\context Voice = "ViolinOne" {
                 f4
                 r2
                 a4
               }
               """)
    end

    test "for a simultaneous voice" do
      voice =
        Voice.new(
          [
            Note.new(Pitch.new(3), Duration.new(1 / 4)),
            Rest.new(Duration.new(1 / 2)),
            Note.new(Pitch.new(6, -0.5, 1), Duration.new(1 / 4))
          ],
          "ViolinOne",
          simultaneous: true
        )

      assert Exactly.to_lilypond(voice) ==
               String.trim("""
               \\context Voice = "ViolinOne" <<
                 f4
                 r2
                 bf'4
               >>
               """)
    end
  end
end
