defmodule Exactly.StartBeamTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Note, Pitch, StartBeam}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the start beam" do
      assert inspect(StartBeam.new()) == "#Exactly.StartBeam<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the start beam" do
      note =
        Note.new(Pitch.new(), Duration.new(1 / 8))
        |> Exactly.attach(StartBeam.new(), direction: :down)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c8
                 _ [
               """)
    end
  end
end
