defmodule Exactly.Duration do
  @moduledoc """
  Models a duration that can be represented by a single Lilypond notehead.

  The duration struct holds two fields, `log` and `dots` representing the
  log (base 2) of the base duration, and the number of dots to attach to the
  duration respectively. This matches how Lilypond models durations.
  """

  defstruct [:log, :dots]

  import Exactly.Utils, only: [frexp: 1]

  @type t :: %__MODULE__{
          log: integer(),
          dots: non_neg_integer()
        }

  def new(value) when is_number(value) do
    case is_printable(value) do
      true ->
        {mant, exp} = frexp(value)
        log = 1 - exp
        {m, e} = frexp(1 - mant)
        dots = -e - if m > 0.5, do: 1, else: 0
        %__MODULE__{log: log, dots: dots}

      false ->
        {:error, :unprintable_duration, value}
    end
  end

  defimpl String.Chars do
    @named_durations ~w(breve longa maxima)
    def to_string(%Exactly.Duration{log: log, dots: dots}) do
      base_duration =
        case log do
          n when n < 0 -> "\\" <> Enum.at(@named_durations, -1 - log)
          _ -> Bitwise.bsl(1, log)
        end

      "#{base_duration}#{String.duplicate(".", dots)}"
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Duration{} = duration, _opts) do
      concat([
        "#Exactly.Duration<",
        to_string(duration),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%Exactly.Duration{} = duration) do
      to_string(duration)
    end
  end

  defp is_printable(value) when is_number(value) do
    {mant, exp} = frexp(value)
    -10 < exp && exp < 5 && elem(frexp(1 - mant), 0) == 0.5
  end
end
