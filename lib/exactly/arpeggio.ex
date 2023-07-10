defmodule Exactly.Arpeggio do
  @moduledoc """
  Models an arpeggio
  """

  use Exactly.Attachable, has_direction: false, fields: [:style]

  @valid_styles ~w(normal arrow_up arrow_down bracket parenthesis parenthesis_dashed)a

  def new(style \\ :normal) when style in @valid_styles do
    %__MODULE__{
      style: style,
      components: [
        before: [build_before_component(style)],
        after: ["\\arpeggio"]
      ]
    }
  end

  defp build_before_component(style) do
    with style <- to_string(style) do
      "\\arpeggio#{Macro.camelize(style)}"
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{style: style}, _opts) do
      concat([
        "#Exactly.Arpeggio<",
        to_string(style),
        ">"
      ])
    end
  end
end
