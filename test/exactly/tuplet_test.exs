defmodule Exactly.TupletTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, Pitch, Tuplet}

  describe "new/2" do
    test "takes a multiplier and a list of elements" do
      tuplet =
        Tuplet.new(2 / 3, [
          Note.new(),
          Note.new(Pitch.new(1, 0, 0)),
          Note.new(Pitch.new(2, -0.5, 0))
        ])

      assert tuplet.multiplier == {2, 3}
      assert length(tuplet.elements) == 3
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the tuplet" do
      tuplet =
        Tuplet.new(2 / 3, [
          Note.new(),
          Note.new(Pitch.new(1, 0, 0)),
          Note.new(Pitch.new(2, -0.5, 0))
        ])

      assert inspect(tuplet) == "#Exactly.Tuplet<(2/3) { c'4 d'4 ef'4 }>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the tuplet" do
      tuplet =
        Tuplet.new(2 / 3, [
          Note.new(),
          Note.new(Pitch.new(1, 0, 0)),
          Note.new(Pitch.new(2, -0.5, 0))
        ])

      assert Exactly.to_lilypond(tuplet) ==
               String.trim("""
               \\tuplet 3/2 {
                 c'4
                 d'4
                 ef'4
               }
               """)
    end
  end
end
