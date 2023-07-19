defmodule Exactly.BendAfter do
  @moduledoc """
  Models a bend after up or down
  """

  use Exactly.Attachable, fields: [:bend], has_direction: false

  def new(bend) do
    %__MODULE__{
      bend: bend,
      components: [
        after: ["\\bendAfter ##{bend}"]
      ]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{bend: bend}, _opts) do
      concat([
        "#Exactly.BendAfter<",
        to_string(bend),
        ">"
      ])
    end
  end
end
