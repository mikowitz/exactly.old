defmodule Exactly.Bookpart do
  @moduledoc """
  Models a Lilypond \\bookpart context
  """

  alias Exactly.{Header, Score}

  defstruct [:scores, header: nil]

  @type t :: %__MODULE__{
          scores: [Score.t()],
          header: Header.t() | nil
        }

  def new(scores \\ []) do
    %__MODULE__{scores: scores}
  end

  def set_header(%__MODULE__{} = bookpart, %Header{} = header) do
    %__MODULE__{bookpart | header: header}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{scores: scores}, _opts) do
      concat([
        "#Exactly.Bookpart<{",
        " #{length(scores)} ",
        "}>"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{scores: scores, header: header}) do
      [
        "\\bookpart {",
        build_header(header),
        Enum.map(scores, fn score ->
          score |> @protocol.to_lilypond() |> indent()
        end),
        "}"
      ]
      |> concat()
    end

    defp build_header(nil), do: nil
    defp build_header(%Header{} = header), do: indent(@protocol.to_lilypond(header))
  end
end
