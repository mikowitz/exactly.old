defmodule Exactly.ClefTest do
  use ExUnit.Case, async: true

  alias Exactly.Clef

  describe "new/1" do
    test "creates a new clef struct from a valid clef name" do
      assert Clef.new(:treble) == %Clef{
               name: :treble,
               octavation: 0,
               octavation_optional: nil
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
               octavation_optional: nil
             }

      assert Clef.new(:treble, octavation: -15, octavation_optional: :parentheses) == %Clef{
               name: :treble,
               octavation: -15,
               octavation_optional: :parentheses
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
      clef = Clef.new(:treble)
      assert Exactly.to_lilypond(clef) == "\\clef \"treble\""
    end

    test "to_lilypond shows octavation" do
      clef = Clef.new(:treble, octavation: -8)
      assert Exactly.to_lilypond(clef) == "\\clef \"treble_8\""

      clef2 = Clef.new(:treble, octavation: 15, octavation_optional: :parentheses)
      assert Exactly.to_lilypond(clef2) == "\\clef \"treble^(15)\""

      clef3 = Clef.new(:treble, octavation: -15, octavation_optional: :brackets)
      assert Exactly.to_lilypond(clef3) == "\\clef \"treble_[15]\""
    end
  end
end
