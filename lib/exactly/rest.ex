defmodule Exactly.Rest do
  @moduledoc """
  Models a Lilypond rest.
  """

  alias Exactly.Duration

  defstruct [:duration]

  @type t :: %__MODULE__{
          duration: Duration.t()
        }

  def new(duration \\ Duration.new(1 / 4)) do
    %__MODULE__{
      duration: duration
    }
  end

  defimpl String.Chars do
    def to_string(%Exactly.Rest{duration: duration}) do
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
    def to_lilypond(%Exactly.Rest{} = rest) do
      to_string(rest)
    end
  end
end
