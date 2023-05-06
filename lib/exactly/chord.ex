defmodule Exactly.Chord do
  @moduledoc """
  Models a Lilypond chord.

  The `Chord` struct holds a list of `Pitch` structs and a `Duration` struct.
  If no pitches are given, the chord functions as an empty placeholder with
  no duration.
  """

  defstruct [:pitches, :duration]

  @type t :: %__MODULE__{
          pitches: [Pitch.t()],
          duration: Duration.t()
        }

  alias Exactly.Duration

  def new(pitches \\ [], duration \\ Duration.new(1 / 4)) do
    %__MODULE__{pitches: pitches, duration: duration}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Chord{pitches: []}, _opts) do
      "#Exactly.Chord<<>>"
    end

    def inspect(%Exactly.Chord{pitches: pitches, duration: duration}, _opts) do
      concat([
        "#Exactly.Chord<",
        "<",
        inspect_pitches(pitches),
        ">",
        to_string(duration),
        ">"
      ])
    end

    defp inspect_pitches(pitches) do
      pitches |> Enum.map_join(" ", &to_string/1)
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%Exactly.Chord{pitches: []}), do: "<>"

    def to_lilypond(%Exactly.Chord{pitches: pitches, duration: duration}) do
      [
        "<",
        Enum.map(pitches, fn p ->
          p |> @protocol.to_lilypond() |> indent()
        end),
        ">#{@protocol.to_lilypond(duration)}"
      ]
      |> List.flatten()
      |> Enum.join("\n")
    end
  end
end
