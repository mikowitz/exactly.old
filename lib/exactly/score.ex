defmodule Exactly.Score do
  @moduledoc """
  Models a Lilypond Score context
  """

  alias Exactly.Header

  defstruct [:elements, header: nil]

  @type t :: %__MODULE__{
          elements: [Exactly.score_element()],
          header: Header.t() | nil
        }

  def new(elements \\ []) do
    %__MODULE__{
      elements: elements
    }
  end

  def set_header(%__MODULE__{} = score, %Header{} = header) do
    %__MODULE__{score | header: header}
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

    def to_lilypond(%@for{elements: elements, header: header}) do
      [
        "\\score {",
        header_to_lilypond(header),
        "  <<",
        Enum.map(elements, fn el ->
          el |> @protocol.to_lilypond() |> indent(2)
        end),
        "  >>",
        "}"
      ]
      |> concat()
    end

    defp header_to_lilypond(nil), do: nil

    defp header_to_lilypond(%Exactly.Header{} = header) do
      indent(@protocol.to_lilypond(header))
    end
  end
end
