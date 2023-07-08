defmodule Exactly.StartTrillSpan do
  @moduledoc """
  Models the beginning of a trill span
  """

  use Exactly.Attachable, fields: [:trill_pitch]

  def new(opts \\ []) do
    trill_pitch = Keyword.get(opts, :trill_pitch, nil)

    %__MODULE__{
      trill_pitch: trill_pitch,
      components: build_components(trill_pitch)
    }
  end

  defp build_components(nil) do
    [
      before: [],
      after: ["\\startTrillSpan"]
    ]
  end

  defp build_components(pitch) do
    [
      before: ["\\pitchedTrill"],
      after: ["\\startTrillSpan #{to_string(pitch)}"]
    ]
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{trill_pitch: trill_pitch}, _opts) do
      concat([
        "#Exactly.StartTrillSpan<",
        inspect_trill_pitch(trill_pitch),
        ">"
      ])
    end

    defp inspect_trill_pitch(nil), do: ""
    defp inspect_trill_pitch(trill_pitch), do: to_string(trill_pitch)
  end
end
