defmodule Exactly.BeamCount do
  @moduledoc """
  Models setting the left and right beam counts for a beamed note
  """

  use Exactly.Attachable, fields: [:left, :right], has_direction: false

  def new(opts \\ []) do
    left = Keyword.get(opts, :left, nil)
    right = Keyword.get(opts, :right, nil)

    %__MODULE__{
      left: left,
      right: right,
      components: [before: build_components(left, right)]
    }
  end

  defp build_components(left, right) do
    [
      build_component(left, "Left"),
      build_component(right, "Right")
    ]
    |> Enum.reject(&is_nil/1)
  end

  defp build_component(nil, _), do: nil
  defp build_component(count, side), do: "\\set stem#{side}BeamCount = ##{count}"

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{left: left, right: right}, _opts) do
      concat([
        "#Exactly.BeamCount<",
        inspect_beam_counts(left, right),
        ">"
      ])
    end

    defp inspect_beam_counts(left, right) do
      [
        inspect_beam_count(left, "left"),
        inspect_beam_count(right, "right")
      ]
      |> Enum.reject(&is_nil/1)
      |> Enum.join(", ")
    end

    defp inspect_beam_count(nil, _), do: nil
    defp inspect_beam_count(count, side), do: "#{side}: #{count}"
  end
end
