defmodule ExactlyTest do
  use ExUnit.Case

  doctest Exactly

  alias Exactly.Articulation
  alias Exactly.StartSlur
  alias Exactly.StopSlur
  alias Exactly.{Barline, Clef, KeySignature, Note, Pitch, TimeSignature}

  describe "attach/2" do
    test "attachables are ordered according to their priority" do
      note =
        Note.new()
        |> Exactly.attach(Barline.new("|"))
        |> Exactly.attach(TimeSignature.new(2, 4))
        |> Exactly.attach(Clef.new(:bass))
        |> Exactly.attach(KeySignature.new(Pitch.new(), :minor))
        |> Exactly.attach(StartSlur.new(), direction: :down)
        |> Exactly.attach(StopSlur.new())
        |> Exactly.attach(Articulation.new(:accent))
        |> Exactly.attach(Articulation.new(:marcato), direction: :up)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\clef "bass"
               \\key c \\minor
               \\time 2/4
               c4
                 )
                 - \\accent
                 ^ \\marcato
                 _ (
               \\bar "|"
               """)
    end
  end
end
