defmodule Exactly.Articulation do
  @moduledoc """
  Models a Lilypond articulation attachment
  """

  use Exactly.Attachable, fields: [:name]

  def new(name) do
    %__MODULE__{
      name: name,
      components: [after: ["\\#{name}"]]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{name: name}, _opts) do
      concat([
        "#Exactly.Articulation<",
        to_string(name),
        ">"
      ])
    end
  end
end
