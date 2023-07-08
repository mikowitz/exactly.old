defmodule Exactly.StartTrillSpanTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, Pitch, StartTrillSpan}

  describe "new/0" do
    test "creates a default trill span start" do
      assert StartTrillSpan.new() == %StartTrillSpan{
               trill_pitch: nil,
               components: [
                 before: [],
                 after: ["\\startTrillSpan"]
               ]
             }
    end
  end

  describe "new/1" do
    test "can define a pitched trill span via options" do
      assert StartTrillSpan.new(trill_pitch: Pitch.new()) == %StartTrillSpan{
               trill_pitch: Pitch.new(),
               components: [
                 before: ["\\pitchedTrill"],
                 after: ["\\startTrillSpan c"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of an unpitched trill span" do
      trill = StartTrillSpan.new()
      assert inspect(trill) == "#Exactly.StartTrillSpan<>"
    end

    test "returns an IEx-ready represenation of a pitched trill span" do
      trill = StartTrillSpan.new(trill_pitch: Pitch.new(1, -0.5, 1))
      assert inspect(trill) == "#Exactly.StartTrillSpan<df'>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for an unpitched trill span" do
      note =
        Note.new()
        |> Exactly.attach(StartTrillSpan.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 - \\startTrillSpan
               """)
    end

    test "returns the correct Lilypond string for pitched trill span" do
      note =
        Note.new()
        |> Exactly.attach(StartTrillSpan.new(trill_pitch: Pitch.new(1)), direction: :down)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\pitchedTrill
               c4
                 _ \\startTrillSpan d
               """)
    end
  end
end
