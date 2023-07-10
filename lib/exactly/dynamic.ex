defmodule Exactly.Dynamic do
  @moduledoc """
  Models a dynamic
  """

  use Exactly.Attachable, fields: [:dynamic]

  @valid_dynamics ~w(ppppp pppp ppp pp p mp mf f ff fff ffff fffff fp sf sff sp spp sfz rfz n)a

  def new(dynamic) when dynamic in @valid_dynamics do
    %__MODULE__{
      dynamic: dynamic,
      components: [after: ["\\#{dynamic}"]]
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{dynamic: dynamic}, _opts) do
      concat([
        "#Exactly.Dynamic<",
        to_string(dynamic),
        ">"
      ])
    end
  end
end
