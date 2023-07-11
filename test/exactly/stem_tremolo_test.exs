defmodule Exactly.StemTremoloTest do
  use ExUnit.Case, async: true

  alias Exactly.{Articulation, Note, StemTremolo}

  describe "new/0" do
    test "defaults to 16th note tremolo flags" do
      assert StemTremolo.new() == %StemTremolo{
               flags: 16,
               components: [after: [":16"]]
             }
    end
  end

  describe "new/1" do
    test "can specify the number of tremolo flags" do
      assert StemTremolo.new(32) == %StemTremolo{
               flags: 32,
               components: [after: [":32"]]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the tremolo flags" do
      assert inspect(StemTremolo.new(64)) == "#Exactly.StemTremolo<64>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the tremolo flags" do
      note =
        Note.new()
        |> Exactly.attach(Articulation.new(:accent))
        |> Exactly.attach(StemTremolo.new(16))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 :16
                 - \\accent
               """)
    end
  end
end
