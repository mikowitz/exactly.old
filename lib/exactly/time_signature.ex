defmodule Exactly.TimeSignature do
  @moduledoc """
  Models a Lilypond time signature
  """

  defstruct [:numerator, :denominator]

  @type t :: %__MODULE__{
          numerator: integer(),
          denominator: integer()
        }

  def new(numerator, denominator) do
    %__MODULE__{numerator: numerator, denominator: denominator}
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

  defimpl Exactly.ToLilypond do
    def to_lilypond(%@for{numerator: n, denominator: d}) do
      "\\time #{n}/#{d}"
    end
  end
end
