defmodule Exactly.ChordTest do
  use ExUnit.Case, async: true

  alias Exactly.{Chord, Duration, Pitch}

  describe "new/1" do
    test "defaults duration to quarter note" do
      chord =
        assert Chord.new([
                 Pitch.new(0, 0, 0),
                 Pitch.new(2, 0, 0),
                 Pitch.new(4, 0, 0)
               ])

      assert chord.duration == Duration.new(1 / 4)
      assert length(chord.pitches) == 3
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the chord" do
      chord =
        Chord.new(
          [
            Pitch.new(0, 0, 0),
            Pitch.new(2, 0, 0),
            Pitch.new(4, 0, 0)
          ],
          Duration.new(1 / 8)
        )

      assert inspect(chord) == "#Exactly.Chord<<c e g>8>"
    end

    test "empty chords do not have a duration printed" do
      assert Chord.new() |> inspect() == "#Exactly.Chord<<>>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the chord" do
      chord =
        Chord.new(
          [
            Pitch.new(0, 0, 0),
            Pitch.new(2, -0.5, 0),
            Pitch.new(4, 0, 0)
          ],
          Duration.new(7 / 8)
        )

      assert chord |> Exactly.to_lilypond() ==
               String.trim("""
               <
                 c
                 ef
                 g
               >2..
               """)
    end

    test "empty chords do not have a duration printed" do
      assert Chord.new() |> Exactly.to_lilypond() == "<>"
    end
  end
end
