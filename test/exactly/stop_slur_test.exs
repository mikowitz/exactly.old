defmodule Exactly.StopSlurTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StopSlur}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the stop slur" do
      assert inspect(StopSlur.new()) == "#Exactly.StopSlur<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the stop slur" do
      note =
        Note.new()
        |> Exactly.attach(StopSlur.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 )
               """)
    end
  end
end
