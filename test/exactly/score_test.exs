defmodule Exactly.ScoreTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Header, Note, Pitch, Rest, Score, Staff, StaffGroup}

  setup do
    score =
      Score.new([
        Staff.new(
          [
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Note.new(Pitch.new(2, -0.5), Duration.new(1 / 4))
          ],
          "Flute"
        ),
        StaffGroup.new(
          [
            Staff.new(
              [
                Rest.new(Duration.new(1 / 4)),
                Note.new(Pitch.new(), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(0, 0, -1), Duration.new(1 / 2))
              ],
              "Cello"
            )
          ],
          "Strings"
        )
      ])

    {:ok, score: score}
  end

  describe "new/1" do
    test "takes a list of containable elements", %{score: score} do
      assert length(score.elements) == 2
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation for the score", %{score: score} do
      assert inspect(score) == "#Exactly.Score<{ 2 }>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the score", %{score: score} do
      assert Exactly.to_lilypond(score) ==
               String.trim("""
               \\score {
                 <<
                   \\context Staff = "Flute" {
                     c4
                     ef4
                   }
                   \\context StaffGroup = "Strings" <<
                     \\context Staff = "Violin" {
                       r4
                       c4
                     }
                     \\context Staff = "Cello" {
                       c,2
                     }
                   >>
                 >>
               }
               """)
    end

    test "header is correctly nested", %{score: score} do
      score = Score.set_header(score, Header.new(piece: "Trio"))

      assert Exactly.to_lilypond(score) ==
               String.trim("""
               \\score {
                 \\header {
                   piece = "Trio"
                 }
                 <<
                   \\context Staff = "Flute" {
                     c4
                     ef4
                   }
                   \\context StaffGroup = "Strings" <<
                     \\context Staff = "Violin" {
                       r4
                       c4
                     }
                     \\context Staff = "Cello" {
                       c,2
                     }
                   >>
                 >>
               }
               """)
    end
  end
end
