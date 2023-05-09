defmodule Exactly.Tuplet do
  @moduledoc """
  Models Lilypond `TimeScaledMusic`
  """

  defstruct [:multiplier, :elements]

  @type t :: %__MODULE__{
          multiplier: {pos_integer(), pos_integer()},
          elements: [Exactly.score_element()]
        }

  def new(multiplier, elements \\ []) do
    %__MODULE__{
      multiplier: Exactly.Utils.to_fraction(multiplier),
      elements: elements
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{multiplier: {n, d}, elements: elements}, _opts) do
      concat([
        "#Exactly.Tuplet<",
        "(#{n}/#{d}) ",
        inspect_elements(elements),
        ">"
      ])
    end

    defp inspect_elements(elements) do
      [
        "{",
        Enum.map(elements, &to_string/1),
        "}"
      ]
      |> List.flatten()
      |> Enum.join(" ")
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{multiplier: {n, d}, elements: elements}) do
      [
        "\\tuplet #{d}/#{n} {",
        Enum.map(elements, fn el ->
          el |> @protocol.to_lilypond() |> indent()
        end),
        "}"
      ]
      |> List.flatten()
      |> Enum.join("\n")
    end
  end
end
