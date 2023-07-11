defmodule Exactly.Ottava do
  @moduledoc """
  Models an ottava offset
  """

  use Exactly.Attachable, has_direction: false, fields: [:octaves]

  def new(octaves \\ 0) do
    %__MODULE__{
      octaves: octaves,
      components: [before: ["\\ottava ##{octaves}"]]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{octaves: octaves}, _opts) do
      concat([
        "#Exactly.Ottava<",
        to_string(octaves),
        ">"
      ])
    end
  end
end
