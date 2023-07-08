defmodule Exactly.StartPianoPedal do
  @moduledoc """
  Models a pedal down marking
  """

  use Exactly.Attachable, has_direction: false, fields: [:pedal]

  @valid_pedals ~w(sustain sostenuto corda)a

  def new(pedal \\ :sustain) when pedal in @valid_pedals do
    %__MODULE__{
      pedal: pedal,
      components: [after: [pedal_component(pedal)]]
    }
  end

  defp pedal_component(:sustain), do: "\\sustainOn"
  defp pedal_component(:sostenuto), do: "\\sostenutoOn"
  defp pedal_component(:corda), do: "\\unaCorda"

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{pedal: pedal}, _opts) do
      concat([
        "#Exactly.StartPianoPedal<",
        to_string(pedal),
        ">"
      ])
    end
  end
end
