defmodule Exactly.StartHairpin do
  @moduledoc """
  Models the beginning of a hairpin
  """

  use Exactly.Attachable, fields: [:shape], priority: 1

  @valid_shapes ~w(< >)a

  def new(shape \\ :<) when shape in @valid_shapes do
    %__MODULE__{
      shape: shape,
      components: [after: ["\\#{shape}"]]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{shape: shape}, _opts) do
      concat([
        "#Exactly.StartHairpin<",
        "\"#{to_string(shape)}\"",
        ">"
      ])
    end
  end
end
