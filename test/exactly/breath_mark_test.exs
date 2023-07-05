defmodule Exactly.BreathMarkTest do
  use ExUnit.Case, async: true

  alias Exactly.BreathMark

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the breath mark" do
      assert inspect(BreathMark.new()) == "#Exactly.BreathMark<>"
    end
  end
end
