defmodule Exactly.RestTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Rest}

  describe "new/0" do
    test "defaults to r4" do
      assert Rest.new() == %Rest{
               duration: %Duration{log: 2, dots: 0}
             }
    end
  end

  describe "new/1" do
    test "can set the duration" do
      assert Rest.new(Duration.new(3 / 8)) == %Rest{
               duration: %Duration{log: 2, dots: 1}
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the rest" do
      assert Rest.new(Duration.new(7 / 32)) |> inspect() == "#Exactly.Rest<r8..>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the rest" do
      assert Rest.new(Duration.new(8)) |> Exactly.to_lilypond() == "r\\maxima"
    end
  end
end
