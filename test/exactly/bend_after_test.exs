defmodule Exactly.BendAfterTest do
  use ExUnit.Case, async: true

  alias Exactly.{BendAfter, Note}

  describe "new/1" do
    test "defines a bend of the given size" do
      assert BendAfter.new(2) == %BendAfter{
               bend: 2,
               components: [
                 after: ["\\bendAfter #2"]
               ]
             }
    end

    test "can be a negative value" do
      assert BendAfter.new(-3) == %BendAfter{
               bend: -3,
               components: [
                 after: ["\\bendAfter #-3"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the bend" do
      assert BendAfter.new(1) |> inspect() == "#Exactly.BendAfter<1>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the bend" do
      note =
        Note.new()
        |> Exactly.attach(BendAfter.new(-3))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\bendAfter #-3
               """)
    end
  end
end
