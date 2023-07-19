defmodule Exactly.LilypondLiteralTest do
  use ExUnit.Case, async: true

  alias Exactly.{LilypondLiteral, Note}

  describe "new/1" do
    test "defaults to being printed before the attachment point" do
      assert LilypondLiteral.new("\\stopStaff") == %LilypondLiteral{
               literal: "\\stopStaff",
               location: :before,
               components: [
                 before: ["\\stopStaff"]
               ]
             }
    end

    test "can take multiple lines as arguments" do
      assert LilypondLiteral.new(["\\stopStaff", "\\startStaff"]) == %LilypondLiteral{
               literal: ["\\stopStaff", "\\startStaff"],
               location: :before,
               components: [
                 before: ["\\stopStaff", "\\startStaff"]
               ]
             }
    end
  end

  describe "new/2" do
    test "can set the position" do
      assert LilypondLiteral.new("\\stopStaff", location: :after) == %LilypondLiteral{
               literal: "\\stopStaff",
               location: :after,
               components: [
                 after: ["\\stopStaff"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the literal" do
      literal = LilypondLiteral.new(["\\stopStaff", "\\startStaff"])

      assert inspect(literal) == "#Exactly.LilypondLiteral<\n  \\stopStaff\n  \\startStaff\n>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the literal" do
      literal = LilypondLiteral.new(["\\stopStaff", "\\startStaff"])

      note = Note.new() |> Exactly.attach(literal)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\stopStaff
               \\startStaff
               c4
               """)
    end

    test "behaves correctly when attaching after" do
      literal = LilypondLiteral.new(["\\stopStaff", "\\startStaff"], location: :after)

      note = Note.new() |> Exactly.attach(literal)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
               \\stopStaff
               \\startStaff
               """)
    end
  end
end
