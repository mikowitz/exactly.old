defmodule Exactly.MultiMeasureRest do
  @moduledoc """
  Models a multi-mesaure rest
  """

  alias Exactly.Duration

  defstruct [:written_duration, attachments: []]

  @type t :: %__MODULE__{
          written_duration: Duration.t()
        }

  def new(duration \\ Duration.new(1)) do
    %__MODULE__{written_duration: duration}
  end

  defimpl String.Chars do
    def to_string(%Exactly.MultiMeasureRest{written_duration: duration}) do
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
    import Exactly.Lilypond.Utils

    def to_lilypond(%Exactly.MultiMeasureRest{} = mm_rest) do
      %{before: attachments_before, after: attachments_after} = attachments_for(mm_rest)

      [
        attachments_before,
        to_string(mm_rest),
        Enum.map(attachments_after, &indent/1)
      ]
      |> concat()
    end
  end
end
