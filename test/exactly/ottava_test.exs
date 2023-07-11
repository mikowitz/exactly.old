defmodule Exactly.OttavaTest do
  use ExUnit.Case, async: true

  alias Exactly.{Note, Ottava}

  describe "new/0" do
    test "defaults to a `loco` ottava" do
      assert Ottava.new() == %Ottava{
               octaves: 0,
               components: [before: ["\\ottava #0"]]
             }
    end
  end

  describe "new/1" do
    test "can set the octave offset" do
      assert Ottava.new(2) == %Ottava{
               octaves: 2,
               components: [before: ["\\ottava #2"]]
             }
    end

    test "can set a negative octave offset" do
      assert Ottava.new(-1) == %Ottava{
               octaves: -1,
               components: [before: ["\\ottava #-1"]]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the ottava" do
      assert inspect(Ottava.new(1)) == "#Exactly.Ottava<1>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the ottava" do
      note =
        Note.new()
        |> Exactly.attach(Ottava.new(1))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\ottava #1
               c4
               """)
    end
  end
end
