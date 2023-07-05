defmodule Exactly.SkipTest do
  use ExUnit.Case, async: true

  alias Exactly.{Articulation, Duration, Skip}

  describe "new/0" do
    test "defaults to r4" do
      assert Skip.new() == %Skip{
               written_duration: %Duration{log: 2, dots: 0}
             }
    end
  end

  describe "new/1" do
    test "can set the duration" do
      assert Skip.new(Duration.new(3 / 8)) == %Skip{
               written_duration: %Duration{log: 2, dots: 1}
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the skip" do
      assert Skip.new(Duration.new(7 / 32)) |> inspect() == "#Exactly.Skip<s8..>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the skip" do
      assert Skip.new(Duration.new(8)) |> Exactly.to_lilypond() == "s\\maxima"
    end

    test "correctly displays attachments" do
      skip =
        Skip.new(Duration.new(1))
        |> Exactly.attach(Articulation.new(:tenuto))

      assert Exactly.to_lilypond(skip) ==
               String.trim("""
               s1
                 - \\tenuto
               """)
    end
  end
end
