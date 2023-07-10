defmodule Exactly.DynamicTest do
  use ExUnit.Case, async: true

  alias Exactly.{Dynamic, Note, StartHairpin, StopHairpin}

  describe "new/1" do
    test "creates a new dynamic" do
      assert Dynamic.new(:mf) == %Dynamic{
               dynamic: :mf,
               components: [
                 after: ["\\mf"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the dynamic" do
      assert inspect(Dynamic.new(:sf)) == "#Exactly.Dynamic<sf>"
    end
  end

  describe "to_lilypond/1" do
    test "correctly orders dynamics among hairpins" do
      note =
        Note.new()
        |> Exactly.attach(Dynamic.new(:f))
        |> Exactly.attach(StartHairpin.new(:>))
        |> Exactly.attach(StopHairpin.new())

      assert Exactly.to_lilypond(note) ==
               String.trim("""
               c4
                 \\!
                 - \\f
                 - \\>
               """)
    end
  end
end
