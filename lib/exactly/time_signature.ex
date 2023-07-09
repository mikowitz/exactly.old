defmodule Exactly.TimeSignature do
  @moduledoc """
  Models a Lilypond time signature
  """

  use Exactly.Attachable, has_direction: false, fields: [:numerator, :denominator], priority: -1

  @type t :: %__MODULE__{
          numerator: integer(),
          denominator: integer(),
          components: Keyword.t()
        }

  def new(numerator, denominator) do
    %__MODULE__{
      numerator: numerator,
      denominator: denominator,
      components: [
        before: ["\\time #{numerator}/#{denominator}"]
      ]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{numerator: n, denominator: d}, _opts) do
      concat([
        "#Exactly.TimeSignature<",
        "#{n}/#{d}",
        ">"
      ])
    end
  end
end
