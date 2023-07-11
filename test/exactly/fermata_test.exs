defmodule Exactly.FermataTest do
  use ExUnit.Case, async: true

  alias Exactly.{Fermata, Note}

  describe "new/0" do
    test "returns a normal fermata" do
      assert Fermata.new() == %Fermata{
               length: :fermata,
               components: [
                 after: ["\\fermata"]
               ]
             }
    end
  end

  describe "new/1" do
    test "can specify the length of the fermata" do
      assert Fermata.new(:shortfermata) == %Fermata{
               length: :shortfermata,
               components: [
                 after: ["\\shortfermata"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the fermata" do
      assert inspect(Fermata.new(:verylongfermata)) == "#Exactly.Fermata<verylongfermata>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the fermata" do
      note =
        Note.new()
        |> Exactly.attach(Fermata.new(), direction: :down)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 _ \\fermata
               """)
    end
  end
end
