defmodule Exactly.Lilypond.Utils do
  @moduledoc false

  def indent(s) do
    s
    |> String.split("\n", trim: true)
    |> Enum.map_join("\n", &"  #{&1}")
  end
end
