defmodule Exactly.MultiMeasureRestTest do
  use ExUnit.Case, async: true

  alias Exactly.{Articulation, Duration, MultiMeasureRest}

  describe "new/0" do
    test "defaults to 'R1'" do
      assert MultiMeasureRest.new() == %MultiMeasureRest{
               written_duration: %Duration{
                 log: 0,
                 dots: 0
               }
             }
    end
  end

  describe "new/1" do
    test "can set the duration" do
      assert MultiMeasureRest.new(Duration.new(1, 5)) == %MultiMeasureRest{
               written_duration: %Duration{
                 log: 0,
                 dots: 0,
                 scale: 5
               }
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the multi-measure rest" do
      assert MultiMeasureRest.new() |> inspect() == "#Exactly.MultiMeasureRest<R1>"

      assert MultiMeasureRest.new(Duration.new(1, 5)) |> inspect() ==
               "#Exactly.MultiMeasureRest<R1*5>"

      assert MultiMeasureRest.new(Duration.new(1, 0.5)) |> inspect() ==
               "#Exactly.MultiMeasureRest<R1*1/2>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the multi-measure rest" do
      assert MultiMeasureRest.new() |> Exactly.to_lilypond() == "R1"

      assert MultiMeasureRest.new(Duration.new(1, 5)) |> Exactly.to_lilypond() ==
               "R1*5"

      assert MultiMeasureRest.new(Duration.new(1, 0.3)) |> Exactly.to_lilypond() ==
               "R1*3/10"
    end

    test "correctly displays attachments" do
      mmr =
        MultiMeasureRest.new(Duration.new(1, 3))
        |> Exactly.attach(Articulation.new(:staccatissimo), direction: :down)

      assert Exactly.to_lilypond(mmr) ==
               String.trim("""
               R1*3
                 _ \\staccatissimo
               """)
    end
  end
end
