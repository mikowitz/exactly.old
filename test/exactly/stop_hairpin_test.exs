defmodule Exactly.StopHairpinTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StopHairpin}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the stop hairpin" do
      assert inspect(StopHairpin.new()) == "#Exactly.StopHairpin<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the stop hairpin" do
      note =
        Note.new()
        |> Exactly.attach(StopHairpin.new(), direction: :up)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\!
               """)
    end
  end
end
