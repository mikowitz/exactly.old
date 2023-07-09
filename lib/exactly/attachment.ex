defmodule Exactly.Attachment do
  @moduledoc """
  Acts as a wrapper for attaching an attachable object to a target
  """

  defstruct [:attachable, :priority, :direction]

  def new(attachable, opts \\ []) do
    %__MODULE__{
      attachable: attachable,
      priority: Keyword.get(opts, :priority, 0),
      direction: attachable_direction(attachable, opts)
    }
  end

  def prepared_components(%__MODULE__{
        attachable: %attachable_struct{components: components},
        direction: direction
      }) do
    components
    |> Enum.map(fn
      {:before, v} ->
        {:before, Enum.map(v, &with_direction(&1, :before, direction))}

      {:after, v} ->
        {:after,
         Enum.map(v, &{with_direction(&1, :after, direction), attachable_struct.should_indent()})}
    end)
  end

  defp with_direction(str, :before, _), do: str
  defp with_direction(str, _, nil), do: str
  defp with_direction(str, _, :neutral), do: "- #{str}"
  defp with_direction(str, _, :up), do: "^ #{str}"
  defp with_direction(str, _, :down), do: "_ #{str}"

  defp attachable_direction(attachable, opts) do
    case Exactly.HasDirection.has_direction(attachable) do
      true -> Keyword.get(opts, :direction, :neutral)
      false -> nil
    end
  end
end
