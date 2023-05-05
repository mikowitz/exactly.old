defmodule Exactly.DurationTest do
  use ExUnit.Case, async: true

  alias Exactly.Duration

  describe "new/1" do
    test "returns a Duration struct for a printable duration" do
      assert Duration.new(1 / 4) == %Duration{log: 2, dots: 0}
      assert Duration.new(7 / 64) == %Duration{log: 4, dots: 2}
    end

    test "returns an error tuple for a non-printable duration" do
      assert Duration.new(1 / 2048) == {:error, :unprintable_duration, 1 / 2048}
      assert Duration.new(16.1) == {:error, :unprintable_duration, 16.1}
      assert Duration.new(5 / 8) == {:error, :unprintable_duration, 5 / 8}
      assert Duration.new(1 / 5) == {:error, :unprintable_duration, 1 / 5}
    end
  end

  describe "inspect/1" do
    assert Duration.new(1 / 4) |> inspect() == "#Exactly.Duration<4>"
  end

  describe "to_lilypond/1" do
    assert Duration.new(1 / 4) |> Exactly.to_lilypond() == "4"
    assert Duration.new(7 / 64) |> Exactly.to_lilypond() == "16.."
    assert Duration.new(2) |> Exactly.to_lilypond() == "\\breve"
    assert Duration.new(6) |> Exactly.to_lilypond() == "\\longa."
    assert Duration.new(15.75) |> Exactly.to_lilypond() == "\\maxima....."
  end
end
