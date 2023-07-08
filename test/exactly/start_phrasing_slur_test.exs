defmodule Exactly.StartPhrasingSlurTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StartPhrasingSlur}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the start of the phrasing slur" do
      assert inspect(StartPhrasingSlur.new()) == "#Exactly.StartPhrasingSlur<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the start of the phrasing slur" do
      note =
        Note.new()
        |> Exactly.attach(StartPhrasingSlur.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 - \\(
               """)
    end
  end
end
