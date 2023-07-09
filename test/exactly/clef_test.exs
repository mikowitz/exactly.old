defmodule Exactly.ClefTest do
  use ExUnit.Case, async: true

  alias Exactly.{Clef, Note}

  describe "new/1" do
    test "creates a new clef struct from a valid clef name" do
      assert Clef.new(:treble) == %Clef{
               name: :treble,
               octavation: 0,
               octavation_optional: nil,
               components: [
                 before: ["\\clef \"treble\""]
               ]
             }
    end

    test "returns an error tuple if given an invalid clef name" do
      assert Clef.new(:trouble) == {:error, :invalid_clef_name, :trouble}
    end
  end

  describe "new/2" do
    test "can set octavation settings via a keyword list" do
      assert Clef.new(:treble, octavation: 8) == %Clef{
               name: :treble,
               octavation: 8,
               octavation_optional: nil,
               components: [
                 before: ["\\clef \"treble^8\""]
               ]
             }

      assert Clef.new(:treble, octavation: -15, octavation_optional: :parentheses) == %Clef{
               name: :treble,
               octavation: -15,
               octavation_optional: :parentheses,
               components: [
                 before: ["\\clef \"treble_(15)\""]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the clef" do
      clef = Clef.new(:treble)
      assert inspect(clef) == "#Exactly.Clef<treble>"
    end

    test "inspect shows octavation" do
      clef = Clef.new(:treble, octavation: -8)
      assert inspect(clef) == "#Exactly.Clef<treble_8>"

      clef2 = Clef.new(:treble, octavation: 15, octavation_optional: :parentheses)
      assert inspect(clef2) == "#Exactly.Clef<treble^(15)>"

      clef3 = Clef.new(:treble, octavation: -15, octavation_optional: :brackets)
      assert inspect(clef3) == "#Exactly.Clef<treble_[15]>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the clef" do
      note = attach_clef_to_note(Clef.new(:treble))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\clef "treble"
               c4
               """)
    end

    test "to_lilypond shows octavation" do
      note =
        Clef.new(:treble, octavation: -8)
        |> attach_clef_to_note()

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\clef "treble_8"
               c4
               """)

      note2 =
        Clef.new(:treble, octavation: 15, octavation_optional: :parentheses)
        |> attach_clef_to_note()

      assert Exactly.to_lilypond(note2) ==
               String.trim("""
               \\clef "treble^(15)"
               c4
               """)

      note3 =
        Clef.new(:treble, octavation: -15, octavation_optional: :brackets)
        |> attach_clef_to_note()

      assert Exactly.to_lilypond(note3) ==
               String.trim("""
               \\clef "treble_[15]"
               c4
               """)
    end
  end

  defp attach_clef_to_note(clef), do: Exactly.attach(Note.new(), clef)
end
