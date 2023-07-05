defmodule Exactly.Skip do
  @moduledoc """
  Models a Lilypond skip rest.
  """

  alias Exactly.Duration

  defstruct [:written_duration, attachments: []]

  @type t :: %__MODULE__{
          written_duration: Duration.t()
        }

  def new(duration \\ Duration.new(1 / 4)) do
    %__MODULE__{
      written_duration: duration
    }
  end

  defimpl String.Chars do
    def to_string(%Exactly.Skip{written_duration: duration}) do
      "s" <> @protocol.to_string(duration)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Skip{} = skip, _opts) do
      concat([
        "#Exactly.Skip<",
        to_string(skip),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%Exactly.Skip{} = skip) do
      %{before: attachments_before, after: attachments_after} = attachments_for(skip)

      [
        attachments_before,
        to_string(skip),
        Enum.map(attachments_after, &indent/1)
      ]
      |> concat()
    end
  end
end
