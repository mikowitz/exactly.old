defmodule Exactly.Book do
  @moduledoc """
  Models a lilypond top-level \\book context
  """

  alias Exactly.{Bookpart, Header}

  defstruct [:bookparts, header: nil, output_name: nil, output_suffix: nil]

  @type t :: %__MODULE__{
          bookparts: [Bookpart.t()],
          header: Header.t() | nil
        }

  def new(bookparts \\ [], opts \\ []) do
    %__MODULE__{
      bookparts: bookparts,
      output_name: Keyword.get(opts, :output_name),
      output_suffix: Keyword.get(opts, :output_suffix)
    }
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

    def to_lilypond(%@for{
          bookparts: bookparts,
          header: header,
          output_suffix: output_suffix,
          output_name: output_name
        }) do
      [
        "\\book {",
        build_book_output_config(output_suffix, output_name),
        build_header(header),
        Enum.map(bookparts, fn bookpart ->
          bookpart |> @protocol.to_lilypond() |> indent()
        end),
        "}"
      ]
      |> concat()
    end

    defp build_book_output_config(output_suffix, output_name) do
      [
        set_output_suffix(output_suffix),
        set_output_name(output_name)
      ]
    end

    defp set_output_suffix(nil), do: nil
    defp set_output_suffix(suffix), do: indent("\\bookOutputSuffix \"#{suffix}\"")

    defp set_output_name(nil), do: nil
    defp set_output_name(name), do: indent("\\bookOutputName \"#{name}\"")

    defp build_header(nil), do: nil
    defp build_header(%Header{} = header), do: indent(@protocol.to_lilypond(header)) <> "\n"
  end
end
