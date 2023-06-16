defmodule Exactly.Container do
  @moduledoc """
  Models a basic wrapper for serial or simultaneous lilypond elements
  """

  defstruct [:elements, :simultaneous]

  @type t :: %__MODULE__{
          elements: [Exactly.score_element()],
          simultaneous: boolean()
        }

  def new(elements \\ [], opts \\ []) do
    %__MODULE__{
      elements: elements,
      simultaneous: Keyword.get(opts, :simultaneous, false)
    }
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Exactly.Inspect

    def inspect(%@for{elements: elements, simultaneous: simultaneous}, _opts) do
      {open, close} = brackets(simultaneous)

      concat([
        "#Exactly.Container<",
        open,
        " #{length(elements)} ",
        close,
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{elements: elements, simultaneous: simultaneous}) do
      {open, close} = brackets(simultaneous)

      [
        open,
        Enum.map(elements, fn el ->
          el |> @protocol.to_lilypond() |> indent()
        end),
        close
      ]
      |> List.flatten()
      |> Enum.join("\n")
    end
  end
end
