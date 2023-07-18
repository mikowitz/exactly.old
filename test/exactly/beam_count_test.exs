defmodule Exactly.BeamCountTest do
  use ExUnit.Case, async: true

  alias Exactly.{BeamCount, Note}

  describe "new/0" do
    test "defaults to not explicitly setting beams" do
      assert BeamCount.new() == %BeamCount{
               left: nil,
               right: nil,
               components: [before: []]
             }
    end
  end

  describe "new/1" do
    test "can set only left beam count" do
      assert BeamCount.new(left: 2) == %BeamCount{
               left: 2,
               right: nil,
               components: [
                 before: [
                   "\\set stemLeftBeamCount = #2"
                 ]
               ]
             }
    end

    test "can set only right beam count" do
      assert BeamCount.new(right: 1) == %BeamCount{
               left: nil,
               right: 1,
               components: [
                 before: [
                   "\\set stemRightBeamCount = #1"
                 ]
               ]
             }
    end

    test "can set both side beam counts" do
      assert BeamCount.new(right: 1, left: 3) == %BeamCount{
               left: 3,
               right: 1,
               components: [
                 before: [
                   "\\set stemLeftBeamCount = #3",
                   "\\set stemRightBeamCount = #1"
                 ]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the beam counts" do
      assert BeamCount.new() |> inspect == "#Exactly.BeamCount<>"
      assert BeamCount.new(left: 1) |> inspect == "#Exactly.BeamCount<left: 1>"
      assert BeamCount.new(right: 2) |> inspect == "#Exactly.BeamCount<right: 2>"

      assert BeamCount.new(left: 1, right: 2) |> inspect ==
               "#Exactly.BeamCount<left: 1, right: 2>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the beam counts" do
      note =
        Note.new()
        |> Exactly.attach(BeamCount.new(right: 2, left: 3))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\set stemLeftBeamCount = #3
               \\set stemRightBeamCount = #2
               c4
               """)
    end
  end
end
