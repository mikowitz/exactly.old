defmodule StartHairpinTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StartHairpin}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the start hairpin" do
      assert inspect(StartHairpin.new()) == "#Exactly.StartHairpin<\"<\">"

      assert inspect(StartHairpin.new(:<)) == "#Exactly.StartHairpin<\"<\">"
      assert inspect(StartHairpin.new(:>)) == "#Exactly.StartHairpin<\">\">"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the default start hairpin" do
      note =
        Note.new()
        |> Exactly.attach(StartHairpin.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 - \\<
               """)
    end

    test "returns the correct Lilypond string for a diminuendo start hairpin" do
      note =
        Note.new()
        |> Exactly.attach(StartHairpin.new(:>), direction: :up)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 ^ \\>
               """)
    end
  end
end
