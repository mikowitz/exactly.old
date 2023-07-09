defmodule Exactly.Chord do
  @moduledoc """
  Models a Lilypond chord.

  The `Chord` struct holds a list of `Pitch` structs and a `Duration` struct.
  If no pitches are given, the chord functions as an empty placeholder with
  no duration.
  """

  alias Exactly.{Duration, Notehead, Pitch}

  defstruct [:noteheads, :written_duration, attachments: []]

  @type t :: %__MODULE__{
          noteheads: [Notehead.t()],
          written_duration: Duration.t()
        }

  def new(noteheads \\ [], duration \\ Duration.new(1 / 4)) do
    %__MODULE__{noteheads: parse_noteheads(noteheads), written_duration: duration}
  end

  defp parse_noteheads(noteheads) do
    Enum.map(noteheads, &parse_notehead/1)
  end

  defp parse_notehead(%Notehead{} = notehead), do: notehead
  defp parse_notehead(%Pitch{} = pitch), do: Notehead.new(pitch)

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Chord{noteheads: noteheads, written_duration: duration}, _opts) do
      concat([
        "#Exactly.Chord<",
        "<",
        inspect_noteheads(noteheads),
        ">",
        to_string(duration),
        ">"
      ])
    end

    defp inspect_noteheads(pitches) do
      pitches |> Enum.map_join(" ", &Exactly.to_lilypond/1)
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%Exactly.Chord{noteheads: noteheads, written_duration: duration} = chord) do
      joiner =
        case noteheads do
          [] -> ""
          _ -> "\n"
        end

      %{before: attachments_before, after: attachments_after} = attachments_for(chord)

      [
        attachments_before,
        [
          "<",
          Enum.map(noteheads, fn n ->
            n |> @protocol.to_lilypond() |> indent()
          end),
          ">#{@protocol.to_lilypond(duration)}"
        ]
        |> concat(joiner),
        attachments_after
      ]
      |> concat()
    end
  end
end
