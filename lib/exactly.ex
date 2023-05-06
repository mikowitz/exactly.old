defmodule Exactly do
  @moduledoc """
  ExactLy provides a procedural, programmatic way to build up a Lilypond score
  using Elixir as the building blocks.
  """

  def to_lilypond(x), do: Exactly.ToLilypond.to_lilypond(x)
end
