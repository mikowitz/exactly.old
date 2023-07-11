defmodule Exactly.Fermata do
  @moduledoc """
  Models a fermata
  """

  use Exactly.Attachable, fields: [:length]

  @valid_lengths ~w(fermata shortfermata veryshortfermata longfermata verylongfermata)a

  def new(length \\ :fermata) when length in @valid_lengths do
    %__MODULE__{
      length: length,
      components: [
        after: ["\\#{length}"]
      ]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{length: length}, _opts) do
      concat([
        "#Exactly.Fermata<",
        to_string(length),
        ">"
      ])
    end
  end
end
