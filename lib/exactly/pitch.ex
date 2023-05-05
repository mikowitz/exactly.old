defmodule Exactly.Pitch do
  defstruct [:note, :alter, :octave]

  @type t :: %__MODULE__{
          note: 0 | 1 | 2 | 3 | 4 | 5 | 6,
          alter: number(),
          octave: integer()
        }

  def new(note \\ 0, alter \\ 0, octave \\ 0) do
    %__MODULE__{note: note, alter: alter, octave: octave}
  end

  defimpl String.Chars do
    @notes ~w(c d e f g a b)
    @accidentals %{
      -1.0 => "ff",
      -0.75 => "tqf",
      -0.5 => "f",
      -0.25 => "qf",
      0.0 => "",
      0.25 => "qs",
      0.5 => "s",
      0.75 => "tqs",
      1.0 => "ss"
    }

    def to_string(%Exactly.Pitch{note: note, alter: alter, octave: octave}) do
      Enum.at(@notes, note) <> Map.get(@accidentals, alter / 1) <> octave_mark(octave)
    end

    defp octave_mark(-1), do: ""
    defp octave_mark(o) when o < -1, do: String.duplicate(",", abs(o) - 1)
    defp octave_mark(o) when o > -1, do: String.duplicate("'", o + 1)
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Pitch{} = pitch, _opts) do
      concat([
        "#Exactly.Pitch<",
        to_string(pitch),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%Exactly.Pitch{} = pitch) do
      to_string(pitch)
    end
  end
end
