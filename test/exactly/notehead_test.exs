defmodule Exactly.NoteheadTest do
  use ExUnit.Case, async: true

  alias Exactly.{Notehead, Pitch}

  describe "new/0" do
    test "defaults to a normal C notehead" do
      assert Notehead.new() == %Notehead{
               written_pitch: Pitch.new(),
               is_cautionary: false,
               is_forced: false,
               is_parethesized: false
             }
    end
  end

  describe "new/1" do
    test "sets the written pitch" do
      notehead = Notehead.new(Pitch.new(1))
      assert notehead.written_pitch == %Pitch{note: 1, alter: 0, octave: 0}
    end
  end

  describe "new/2" do
    test "sets the written pitch and accidental/parenthesized options" do
      notehead = Notehead.new(Pitch.new(2), is_cautionary: true)
      assert notehead.is_cautionary
      refute notehead.is_forced
      refute notehead.is_parethesized
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the notehead" do
      notehead = Notehead.new(Pitch.new(), is_forced: true)
      assert inspect(notehead) == "#Exactly.Notehead<c!>"
    end

    test "returns an IEx-ready represenation of a forced and cautionary notehead" do
      notehead = Notehead.new(Pitch.new(), is_forced: true, is_cautionary: true)
      assert inspect(notehead) == "#Exactly.Notehead<c!?>"
    end

    test "returns an IEx-ready represenation of a parenthesized notehead" do
      notehead = Notehead.new(Pitch.new(), is_parethesized: true)
      assert inspect(notehead) == "#Exactly.Notehead<(c)>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the notehead" do
      notehead = Notehead.new()

      assert Exactly.to_lilypond(notehead) == "c"
    end

    test "returns the correct Lilypond string for a parenthesized, forced, cautionary notehead" do
      notehead =
        Notehead.new(Pitch.new(2), is_parethesized: true, is_forced: true, is_cautionary: true)

      assert Exactly.to_lilypond(notehead) ==
               String.trim("""
               \\parenthesize
               e!?
               """)
    end
  end
end
