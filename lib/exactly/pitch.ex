defmodule Exactly.Pitch do
  @moduledoc """
  Models a quartertone pitch.

  The `Pitch` struct holds three fields, an index for the diatonic pitch class
  (C = 0), a float indicating the accidental (0 = natural, 0.25 = quarter sharp,
  0.5 = sharp, 1.0 = double sharp), and the octave (0 = middle C octave). This
  matches how Lilypond models pitch data.
  """

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

    defp octave_mark(0), do: ""
    defp octave_mark(o) when o < 0, do: String.duplicate(",", abs(o))
    defp octave_mark(o) when o > 0, do: String.duplicate("'", o)
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
