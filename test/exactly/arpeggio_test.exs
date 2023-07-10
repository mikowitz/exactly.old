defmodule Exactly.ArpeggioTest do
  use ExUnit.Case, async: true

  alias Exactly.{Arpeggio, Chord, Pitch}

  describe "new/0" do
    test "returns an ordinary arpeggio with no direction specified" do
      assert Arpeggio.new() == %Arpeggio{
               style: :normal,
               components: [
                 before: ["\\arpeggioNormal"],
                 after: ["\\arpeggio"]
               ]
             }
    end
  end

  describe "new/1" do
    test "can specify the direction for the arpeggio" do
      assert Arpeggio.new(:arrow_up) == %Arpeggio{
               style: :arrow_up,
               components: [
                 before: ["\\arpeggioArrowUp"],
                 after: ["\\arpeggio"]
               ]
             }
    end

    test "can specify alternative arpeggio styles" do
      assert Arpeggio.new(:parenthesis) == %Arpeggio{
               style: :parenthesis,
               components: [
                 before: ["\\arpeggioParenthesis"],
                 after: ["\\arpeggio"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the arpeggio" do
      assert Arpeggio.new(:bracket) |> inspect() == "#Exactly.Arpeggio<bracket>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the arpeggio" do
      chord =
        Chord.new([Pitch.new(0), Pitch.new(2), Pitch.new(4), Pitch.new(0, 0, 1)])
        |> Exactly.attach(Arpeggio.new(:arrow_down))

      assert Exactly.to_lilypond(chord) ==
               String.trim("""
               \\arpeggioArrowDown
               <
                 c
                 e
                 g
                 c'
               >4
                 \\arpeggio
               """)
    end
  end
end
