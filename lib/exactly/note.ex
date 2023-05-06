defmodule Exactly.Note do
  @moduledoc """
  Models a Lilypond note event.
  """

  defstruct [:duration, :pitch]

  @type t :: %__MODULE__{
          duration: Exactly.Duration.t(),
          pitch: Exactly.Pitch.t()
        }

  alias Exactly.{Duration, Pitch}

  def new(pitch \\ Pitch.new(), duration \\ Duration.new(1 / 4)) do
    %__MODULE__{
      duration: duration,
      pitch: pitch
    }
  end

  defimpl String.Chars do
    def to_string(%Exactly.Note{pitch: pitch, duration: duration}) do
      @protocol.to_string(pitch) <> @protocol.to_string(duration)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Note{} = note, _opts) do
      concat([
        "#Exactly.Note<",
        to_string(note),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%Exactly.Note{} = note) do
      to_string(note)
    end
  end
end
