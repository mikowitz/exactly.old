defmodule Exactly.StopBeamTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Note, Pitch, StopBeam}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the stop beam" do
      assert inspect(StopBeam.new()) == "#Exactly.StopBeam<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the stop beam" do
      note =
        Note.new(Pitch.new(), Duration.new(1 / 8))
        |> Exactly.attach(StopBeam.new(), direction: :down)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c8
                 ]
               """)
    end
  end
end
