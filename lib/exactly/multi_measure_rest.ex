defmodule Exactly.MultiMeasureRest do
  @moduledoc """
  Models a multi-mesaure rest
  """

  defstruct [:duration]

  @type t :: %__MODULE__{
          duration: Duration.t()
        }

  alias Exactly.Duration

  def new(duration \\ Duration.new(1)) do
    %__MODULE__{duration: duration}
  end

  defimpl String.Chars do
    def to_string(%Exactly.MultiMeasureRest{duration: duration}) do
      "R" <> @protocol.to_string(duration)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.MultiMeasureRest{} = mm_rest, _opts) do
      concat([
        "#Exactly.MultiMeasureRest<",
        to_string(mm_rest),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%Exactly.MultiMeasureRest{} = mm_rest), do: to_string(mm_rest)
  end
end
