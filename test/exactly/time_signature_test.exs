defmodule Exactly.TimeSignatureTest do
  use ExUnit.Case, async: true

  alias Exactly.TimeSignature

  describe "new/2" do
    test "returns a time signature holding a basic fraction" do
      assert TimeSignature.new(2, 4) == %TimeSignature{numerator: 2, denominator: 4}
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the time signature" do
      assert TimeSignature.new(4, 4) |> inspect == "#Exactly.TimeSignature<4/4>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the time signature" do
      assert TimeSignature.new(3, 8) |> Exactly.to_lilypond() == "\\time 3/8"
    end
  end
end
