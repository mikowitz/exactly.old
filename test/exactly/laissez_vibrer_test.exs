defmodule Exactly.LaissezVibrerTest do
  use ExUnit.Case, async: true

  alias Exactly.{LaissezVibrer, Note}

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the laissez vibrer tie" do
      assert inspect(LaissezVibrer.new()) == "#Exactly.LaissezVibrer<>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string the laissez vibrer tie" do
      note =
        Note.new()
        |> Exactly.attach(LaissezVibrer.new(), direction: :up)

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 ^ \\laissezVibrer
               """)
    end
  end
end
