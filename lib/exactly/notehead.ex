defmodule Exactly.Notehead do
  @moduledoc """
  Models a notehead
  """

  alias Exactly.Pitch

  defstruct [:written_pitch, is_cautionary: false, is_forced: false, is_parethesized: false]

  @type t :: %__MODULE__{
          written_pitch: Pitch.t(),
          is_cautionary: boolean(),
          is_forced: boolean(),
          is_parethesized: boolean()
        }

  def new(written_pitch \\ Pitch.new(), opts \\ []) do
    %__MODULE__{
      written_pitch: written_pitch,
      is_cautionary: Keyword.get(opts, :is_cautionary, false),
      is_forced: Keyword.get(opts, :is_forced, false),
      is_parethesized: Keyword.get(opts, :is_parethesized, false)
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{written_pitch: pitch} = notehead, _opts) do
      {open, close} = parentheses(notehead)

      concat([
        "#Exactly.Notehead<",
        open,
        to_string(pitch),
        forced_mark(notehead),
        cautionary_mark(notehead),
        close,
        ">"
      ])
    end

    defp parentheses(%@for{is_parethesized: true}), do: {"(", ")"}
    defp parentheses(_), do: {"", ""}

    defp forced_mark(%@for{is_forced: true}), do: "!"
    defp forced_mark(_), do: ""

    defp cautionary_mark(%@for{is_cautionary: true}), do: "?"
    defp cautionary_mark(_), do: ""
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{written_pitch: pitch} = notehead) do
      [
        parenthesized_mark(notehead),
        to_string(pitch),
        forced_mark(notehead),
        cautionary_mark(notehead)
      ]
      |> concat("")
    end

    defp parenthesized_mark(%@for{is_parethesized: true}), do: "\\parenthesize\n"
    defp parenthesized_mark(_), do: ""

    defp forced_mark(%@for{is_forced: true}), do: "!"
    defp forced_mark(_), do: ""

    defp cautionary_mark(%@for{is_cautionary: true}), do: "?"
    defp cautionary_mark(_), do: ""
  end
end
