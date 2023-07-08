defmodule Exactly.StopPianoPedal do
  @moduledoc """
  Models a pedal up marking
  """

  use Exactly.Attachable, has_direction: false, fields: [:pedal]

  @valid_pedals ~w(sustain sostenuto corda)a

  def new(pedal \\ :sustain) when pedal in @valid_pedals do
    %__MODULE__{
      pedal: pedal,
      components: [after: [pedal_component(pedal)]]
    }
  end

  defp pedal_component(:sustain), do: "\\sustainOff"
  defp pedal_component(:sostenuto), do: "\\sostenutoOff"
  defp pedal_component(:corda), do: "\\treCorde"

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{pedal: pedal}, _opts) do
      concat([
        "#Exactly.StopPianoPedal<",
        to_string(pedal),
        ">"
      ])
    end
  end
end
