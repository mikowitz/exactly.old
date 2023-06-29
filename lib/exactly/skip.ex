defmodule Exactly.Skip do
  @moduledoc """
  Models a Lilypond skip rest.
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
    def to_string(%Exactly.Skip{duration: duration}) do
      "r" <> @protocol.to_string(duration)
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
    def to_lilypond(%Exactly.Skip{} = skip) do
      to_string(skip)
    end
  end
end
