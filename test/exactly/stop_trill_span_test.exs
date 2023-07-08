defmodule Exactly.StopTrillSpanTest do
  use ExUnit.Case, async: true

  alias Exactly.StopTrillSpan

  alias Exactly.{Note, StopTrillSpan}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the stop trill span" do
      assert inspect(StopTrillSpan.new()) == "#Exactly.StopTrillSpan<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the stop trill span" do
      note =
        Note.new()
        |> Exactly.attach(StopTrillSpan.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\stopTrillSpan
               """)
    end
  end
end
