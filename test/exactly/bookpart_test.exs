defmodule Exactly.BookpartTest do
  use ExUnit.Case, async: true

  alias Exactly.{Bookpart, Header, Note, Pitch, Score}

  setup do
    {
      :ok,
      score1: Score.new([Note.new()]), score2: Score.new([Note.new(Pitch.new(1))])
    }
  end

  describe "new/1" do
    test "takes a list of score structs", context do
      bookpart = Bookpart.new([context.score1, context.score2])

      assert length(bookpart.scores) == 2
      assert is_nil(bookpart.header)
    end
  end

  describe "set_header/2" do
    test "can add a header", context do
      bookpart =
        Bookpart.new([context.score1, context.score2])
        |> Bookpart.set_header(Header.new(title: "Bookpart 1"))

      assert bookpart.header == %Header{settings: [title: "Bookpart 1"]}
    end
  end

  describe "inspect/1" do
    test "returns an Iex-ready represenation for the bookpart", context do
      bookpart = Bookpart.new([context.score1, context.score2])

      assert inspect(bookpart) == "#Exactly.Bookpart<{ 2 }>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the bookpart", context do
      bookpart =
        Bookpart.new([context.score1, context.score2])
        |> Bookpart.set_header(Header.new(title: "Bookpart Test"))

      assert Exactly.to_lilypond(bookpart) ==
               String.trim("""
               \\bookpart {
                 \\header {
                   title = "Bookpart Test"
                 }
                 \\score {
                   <<
                     c4
                   >>
                 }
                 \\score {
                   <<
                     d4
                   >>
                 }
               }
               """)
    end
  end
end
