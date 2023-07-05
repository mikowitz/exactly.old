defmodule Exactly.NoteTest do
  use ExUnit.Case, async: true

  alias Exactly.{Articulation, Duration, Note, Notehead, Pitch}

  describe "new/0" do
    test "defaults to c'4" do
      assert Note.new() == %Note{
               written_duration: %Duration{
                 log: 2,
                 dots: 0
               },
               notehead: %Notehead{
                 written_pitch: %Pitch{
                   note: 0,
                   alter: 0,
                   octave: 0
                 },
                 is_forced: false,
                 is_cautionary: false,
                 is_parethesized: false
               }
             }
    end
  end

  describe "new/2" do
    test "takes pitch and duration arguments" do
      assert Note.new(Pitch.new(0, 0.5, 2), Duration.new(1 / 2)) == %Note{
               written_duration: %Duration{log: 1, dots: 0},
               notehead: %Notehead{
                 written_pitch: %Pitch{
                   note: 0,
                   alter: 0.5,
                   octave: 2
                 },
                 is_forced: false,
                 is_cautionary: false,
                 is_parethesized: false
               }
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the note" do
      assert Note.new(Pitch.new(0, 0.5, 2), Duration.new(1 / 2)) |> inspect() ==
               "#Exactly.Note<cs''2>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the note" do
      assert Note.new(Pitch.new(2, -0.5, -2), Duration.new(3 / 2)) |> Exactly.to_lilypond() ==
               "ef,,1."
    end

    test "correctly displays attachments" do
      note =
        Note.new()
        |> Exactly.attach(Articulation.new(:accent))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 - \\accent
               """)
    end
  end
end
