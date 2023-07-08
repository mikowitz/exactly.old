defmodule Exactly.StopPianoPedalTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StopPianoPedal}

  describe "new/0" do
    test "defaults to the sustain pedal" do
      assert StopPianoPedal.new() == %StopPianoPedal{
               pedal: :sustain,
               components: [
                 after: ["\\sustainOff"]
               ]
             }
    end
  end

  describe "new/1" do
    test "can take another pedal type as an argument" do
      assert StopPianoPedal.new(:corda) == %StopPianoPedal{
               pedal: :corda,
               components: [
                 after: ["\\treCorde"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the pedal stop" do
      pedal = StopPianoPedal.new(:sostenuto)

      assert inspect(pedal) == "#Exactly.StopPianoPedal<sostenuto>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the pedal stop" do
      note =
        Note.new()
        |> Exactly.attach(StopPianoPedal.new(:sostenuto))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\sostenutoOff
               """)
    end
  end
end
