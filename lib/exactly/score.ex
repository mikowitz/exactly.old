defmodule Exactly.Score do
  @moduledoc """
  Models a Lilypond Score context
  """

  defstruct [:elements]

  def new(elements \\ []) do
    %__MODULE__{
      elements: elements
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{elements: elements}, _opts) do
      concat([
        "#Exactly.Score<",
        "{",
        " #{length(elements)} ",
        "}",
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{elements: elements}) do
      [
        "\\score {",
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
