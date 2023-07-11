defmodule Exactly.TieTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, Tie}

  describe "new/0" do
    test "creates a repeat tie" do
      assert Tie.new() == %Tie{
               components: [after: ["~"]]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the tie" do
      assert inspect(Tie.new()) == "#Exactly.Tie<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the tie" do
      note =
        Note.new()
        |> Exactly.attach(Tie.new(), direction: :down)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 _ ~
               """)
    end
  end
end
