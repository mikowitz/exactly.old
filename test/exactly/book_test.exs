defmodule Exactly.BookTest do
  use ExUnit.Case, async: true

  alias Exactly.{Book, Bookpart, Header, Note, Pitch, Score}

  setup do
    score1 =
      Score.new([Note.new()])
      |> Score.set_header(Header.new(title: "Score 1"))

    score2 = Score.new([Note.new(Pitch.new(1))])

    bookpart1 =
      Bookpart.new([score1])
      |> Bookpart.set_header(Header.new(title: "Bookpart1"))

    {
      :ok,
      bookpart1: bookpart1, bookpart2: Bookpart.new([score2])
    }
  end

  describe "new/1" do
    test "takes a list of bookpart structs", context do
      book = Book.new([context.bookpart1, context.bookpart2])

      assert length(book.bookparts) == 2
      assert is_nil(book.header)
    end
  end

  describe "new/2" do
    test "can take an optional keyword list of output settings", context do
      book = Book.new([context.bookpart1], output_suffix: "test", output_name: "my-score")

      assert book.output_suffix == "test"
      assert book.output_name == "my-score"
    end
  end

  describe "set_header/2" do
    test "can add a header", context do
      book =
        Book.new([context.bookpart1, context.bookpart2])
        |> Book.set_header(Header.new(title: "Book 1"))

      assert book.header == %Header{settings: [title: "Book 1"]}
    end
  end

  describe "inspect/1" do
    test "returns an Iex-ready represenation for the book", context do
      book = Book.new([context.bookpart1, context.bookpart2])

      assert inspect(book) == "#Exactly.Book<{ 2 }>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the book", context do
      book = Book.new([context.bookpart1, context.bookpart2])

      assert Exactly.to_lilypond(book) ==
               String.trim("""
               \\book {
                 \\bookpart {
                   \\header {
                     title = "Bookpart1"
                   }
                   \\score {
                     \\header {
                       title = "Score 1"
                     }
                     <<
                       c4
                     >>
                   }
                 }
                 \\bookpart {
                   \\score {
                     <<
                       d4
                     >>
                   }
                 }
               }
               """)
    end

    test "returns the correct Lilypond string for the book including bookOutput settings",
         context do
      book =
        Book.new([context.bookpart1, context.bookpart2],
          output_name: "output-score",
          output_suffix: "suffix"
        )

      assert Exactly.to_lilypond(book) ==
               String.trim("""
               \\book {
                 \\bookOutputSuffix "suffix"
                 \\bookOutputName "output-score"
                 \\bookpart {
                   \\header {
                     title = "Bookpart1"
                   }
                   \\score {
                     \\header {
                       title = "Score 1"
                     }
                     <<
                       c4
                     >>
                   }
                 }
                 \\bookpart {
                   \\score {
                     <<
                       d4
                     >>
                   }
                 }
               }
               """)
    end
  end
end
