defmodule Exactly.KeySignatureTest do
  use ExUnit.Case, async: true

  alias Exactly.{KeySignature, Note, Pitch}

  describe "new/1" do
    test "mode defaults to major" do
      assert KeySignature.new(Pitch.new()) == %KeySignature{
               pitch: %Pitch{
                 note: 0,
                 alter: 0,
                 octave: 0
               },
               mode: :major,
               components: [
                 before: ["\\key c \\major"]
               ]
             }
    end
  end

  describe "new/2" do
    test "returns a struct with a valid mode" do
      assert KeySignature.new(Pitch.new(1), :minor) == %KeySignature{
               pitch: %Pitch{
                 note: 1,
                 alter: 0,
                 octave: 0
               },
               mode: :minor,
               components: [
                 before: ["\\key d \\minor"]
               ]
             }
    end

    test "returns an error tuple when given an invalid mode" do
      assert KeySignature.new(Pitch.new(), :majore) ==
               {:error, :invalid_key_signature_mode, :majore}
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the header block" do
      key_sig = KeySignature.new(Pitch.new())
      assert inspect(key_sig) == "#Exactly.KeySignature<c major>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the keysignature" do
      note =
        Note.new()
        |> Exactly.attach(KeySignature.new(Pitch.new(3, 0.5), :lydian))

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               \\key fs \\lydian
               c4
               """)
    end
  end
end
