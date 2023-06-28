defmodule Exactly.Book do
  @moduledoc """
  Models a lilypond top-level \\book context
  """

  alias Exactly.{Bookpart, Header}

  defstruct [:bookparts, header: nil]

  @type t :: %__MODULE__{
          bookparts: [Bookpart.t()],
          header: Header.t() | nil
        }

  def new(bookparts \\ []) do
    %__MODULE__{bookparts: bookparts}
  end

  def set_header(%__MODULE__{} = book, %Header{} = header) do
    %__MODULE__{book | header: header}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{bookparts: bookparts}, _opts) do
      concat([
        "#Exactly.Book<{",
        " #{length(bookparts)} ",
        "}>"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{bookparts: bookparts, header: header}) do
      [
        "\\book {",
        build_header(header),
        Enum.map(bookparts, fn bookpart ->
          bookpart |> @protocol.to_lilypond() |> indent()
        end),
        "}"
      ]
      |> concat()
    end

    defp build_header(nil), do: nil
    defp build_header(%Header{} = header), do: indent(@protocol.to_lilypond(header)) <> "\n"
  end
end
