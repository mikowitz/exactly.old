defmodule Exactly.StartSlurTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StartSlur}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the start of the slur" do
      assert inspect(StartSlur.new()) == "#Exactly.StartSlur<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the start of the slur" do
      note =
        Note.new()
        |> Exactly.attach(StartSlur.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 - (
               """)
    end
  end
end
