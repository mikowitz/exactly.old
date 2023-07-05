defmodule Exactly.BreathMark do
  @moduledoc """
  Models a Lilypond breath mark
  """

  use Exactly.Attachable, has_direction: false

  def new do
    %__MODULE__{
      components: [after: ["\\breathe"]]
    }
  end

  defimpl Inspect do
    def inspect(%@for{}, _opts), do: "#Exactly.BreathMark<>"
  end
end
