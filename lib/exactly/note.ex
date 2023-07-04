defmodule Exactly.Note do
  @moduledoc """
  Models a Lilypond note event.
  """

  alias Exactly.{Duration, Notehead, Pitch}

  defstruct [:written_duration, :notehead]

  @type t :: %__MODULE__{
          written_duration: Duration.t(),
          notehead: Notehead.t()
        }

  def new(notehead \\ Notehead.new(), duration \\ Duration.new(1 / 4))

  def new(%Notehead{} = notehead, duration) do
    %__MODULE__{
      written_duration: duration,
      notehead: notehead
    }
  end

  def new(%Pitch{} = pitch, duration) do
    %__MODULE__{
      written_duration: duration,
      notehead: Notehead.new(pitch)
    }
  end

  defimpl String.Chars do
    def to_string(%Exactly.Note{notehead: notehead, written_duration: duration}) do
      Exactly.to_lilypond(notehead) <> @protocol.to_string(duration)
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
