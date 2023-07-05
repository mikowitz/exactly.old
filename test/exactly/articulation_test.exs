defmodule Exactly.ArticulationTest do
  use ExUnit.Case, async: true

  alias Exactly.Articulation

  describe "new/1" do
    test "creates an articulation with the given name" do
      assert Articulation.new(:accent) == %Articulation{
               name: :accent,
               components: [
                 after: ["\\accent"]
               ]
             }
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the articulation" do
      articulation = Articulation.new(:staccato)
      assert inspect(articulation) == "#Exactly.Articulation<staccato>"
    end
  end
end
