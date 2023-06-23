defmodule Exactly.PitchTest do
  use ExUnit.Case, async: true

  alias Exactly.Pitch

  describe "new" do
    test "new/0 defaults to middle C" do
      assert Pitch.new() == %Pitch{note: 0, alter: 0, octave: 0}
    end

    test "new/1 defaults to a natural pitch in the middle C octave" do
      assert Pitch.new(4) == %Pitch{note: 4, alter: 0, octave: 0}
    end

    test "new/2 sets the pitch and alteration in the middle C octave" do
      assert Pitch.new(3, 0.5) == %Pitch{note: 3, alter: 0.5, octave: 0}
    end

    test "new/3 also sets the octave (0 = middle C octave)" do
      assert Pitch.new(2, 0, -1) == %Pitch{note: 2, alter: 0, octave: -1}
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the pitch" do
      assert Pitch.new() |> inspect() == "#Exactly.Pitch<c>"
      assert Pitch.new(4) |> inspect() == "#Exactly.Pitch<g>"
      assert Pitch.new(3, -0.25) |> inspect() == "#Exactly.Pitch<fqf>"
      assert Pitch.new(2, 0, 2) |> inspect() == "#Exactly.Pitch<e''>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the pitch" do
      assert Pitch.new() |> Exactly.to_lilypond() == "c"
      assert Pitch.new(4) |> Exactly.to_lilypond() == "g"
      assert Pitch.new(3, 0.5) |> Exactly.to_lilypond() == "fs"
      assert Pitch.new(2, 0, -1) |> Exactly.to_lilypond() == "e,"
    end
  end
end
