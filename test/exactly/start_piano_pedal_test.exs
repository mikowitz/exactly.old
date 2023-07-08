defmodule Exactly.StartPianoPedalTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, StartPianoPedal}

  describe "new/0" do
    test "defaults to the sustain pedal" do
      assert StartPianoPedal.new() == %StartPianoPedal{
               pedal: :sustain,
               components: [
                 after: ["\\sustainOn"]
               ]
             }
    end
  end

  describe "new/1" do
    test "can take another pedal type as an argument" do
      assert StartPianoPedal.new(:corda) == %StartPianoPedal{
               pedal: :corda,
               components: [
                 after: ["\\unaCorda"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the pedal start" do
      pedal = StartPianoPedal.new(:sostenuto)

      assert inspect(pedal) == "#Exactly.StartPianoPedal<sostenuto>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the pedal start" do
      note =
        Note.new()
        |> Exactly.attach(StartPianoPedal.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\sustainOn
               """)
    end
  end
end
