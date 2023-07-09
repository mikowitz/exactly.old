defmodule Exactly.TimeSignatureTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, TimeSignature}

  describe "new/2" do
    test "returns a time signature holding a basic fraction" do
      assert TimeSignature.new(2, 4) == %TimeSignature{
               numerator: 2,
               denominator: 4,
               components: [
                 before: ["\\time 2/4"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the time signature" do
      assert TimeSignature.new(4, 4) |> inspect == "#Exactly.TimeSignature<4/4>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the time signature" do
      note =
        Note.new()
        |> Exactly.attach(TimeSignature.new(3, 8))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\time 3/8
               c4
               """)
    end
  end
end
