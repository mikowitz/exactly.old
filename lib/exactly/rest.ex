defmodule Exactly.Rest do
  @moduledoc """
  Models a Lilypond rest.
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
    def to_string(%Exactly.Rest{written_duration: duration}) do
      "r" <> @protocol.to_string(duration)
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%Exactly.Rest{} = rest, _opts) do
      concat([
        "#Exactly.Rest<",
        to_string(rest),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%Exactly.Rest{} = rest) do
      %{before: attachments_before, after: attachments_after} = attachments_for(rest)

      [
        attachments_before,
        to_string(rest),
        attachments_after
      ]
      |> concat()
    end
  end
end
