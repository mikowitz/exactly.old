defmodule Exactly.BarlineTest do
  use ExUnit.Case, async: true

  alias Exactly.Barline

  describe "new/0" do
    test "defaults to a regular | barline" do
      assert Barline.new() == %Barline{barline: "|"}
    end
  end

  describe "new/1" do
    test "returns a Barline when a valid barline is given" do
      assert Barline.new(".") == %Barline{barline: "."}
    end

    test "returns an error tuple when an invalid barline is given" do
      assert Barline.new("/") == {:error, :invalid_barline, "/"}
    end

    test "the empty string is a valid barline" do
      assert Barline.new("") == %Barline{barline: ""}
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the barline" do
      assert Barline.new() |> inspect == "#Exactly.Barline<\"|\">"
    end

    test "reasonable behaviour for the empty string barline" do
      assert Barline.new("") |> inspect == "#Exactly.Barline<\"\">"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the barline" do
      assert Barline.new(":|.|:") |> Exactly.to_lilypond() == "\\bar \":|.|:\""
    end
  end
end
