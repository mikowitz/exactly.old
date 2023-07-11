defmodule Exactly.RepeatTieTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, RepeatTie}

  describe "new/0" do
    test "creates a repeat tie" do
      assert RepeatTie.new() == %RepeatTie{
               components: [after: ["\\repeatTie"]]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the repeat tie" do
      assert inspect(RepeatTie.new()) == "#Exactly.RepeatTie<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the repeat tie" do
      note =
        Note.new()
        |> Exactly.attach(RepeatTie.new(), direction: :up)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 ^ \\repeatTie
               """)
    end
  end
end
