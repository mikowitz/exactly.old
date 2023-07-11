defmodule Exactly.StemTremolo do
  @moduledoc """
  Models a tremolo on a single stem
  """

  use Exactly.Attachable, has_direction: false, fields: [:flags], priority: -100

  def new(flags \\ 16) do
    %__MODULE__{
      flags: flags,
      components: [after: [":#{flags}"]]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{flags: flags}, _opts) do
      concat([
        "#Exactly.StemTremolo<",
        to_string(flags),
        ">"
      ])
    end
  end
end
