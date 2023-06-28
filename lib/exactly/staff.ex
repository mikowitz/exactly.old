defmodule Exactly.Staff do
  @moduledoc """
  Models a Lilypond staff context
  """

  defstruct [:elements, :name, :simultaneous]

  @type t :: %__MODULE__{
          elements: [Exactly.score_element()],
          name: String.t() | nil,
          simultaneous: boolean()
        }

  def new(elements \\ [], name \\ nil, opts \\ []) do
    %__MODULE__{
      elements: elements,
      name: name,
      simultaneous: Keyword.get(opts, :simultaneous, false)
    }
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Exactly.Inspect

    def inspect(%@for{elements: elements, name: name, simultaneous: simultaneous}, _opts) do
      {open, close} = brackets(name, simultaneous)

      concat([
        "#Exactly.Staff<",
        open,
        " #{length(elements)} ",
        close,
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{elements: elements, name: name, simultaneous: simultaneous}) do
      {open, close} = brackets("Staff", name, simultaneous)

      [
        open,
        Enum.map(elements, fn el ->
          el |> @protocol.to_lilypond() |> indent()
        end),
        close
      ]
      |> concat()
    end
  end
end
