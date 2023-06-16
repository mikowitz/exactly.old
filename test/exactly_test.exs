defmodule ExactlyTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  doctest Exactly

  alias Exactly.Note

  describe "show/1" do
    test "saves, compiles and opens an exactly score element" do
      output =
        capture_io(fn ->
          Note.new() |> Exactly.show()
        end)

      assert Regex.match?(
               ~r/#{Exactly.lilypond_executable()} -s -o (.*) \1\.ly\nopen \1\.pdf/,
               output
             )
    end
  end
end
