defmodule Exactly.StopPhrasingSlurTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StopPhrasingSlur}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the stop phrasing slur" do
      assert inspect(StopPhrasingSlur.new()) == "#Exactly.StopPhrasingSlur<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the stop phrasing slur" do
      note =
        Note.new()
        |> Exactly.attach(StopPhrasingSlur.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\)
               """)
    end
  end
end
