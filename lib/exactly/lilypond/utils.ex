defmodule Exactly.Lilypond.Utils do
  @moduledoc false

  def indent(s, depth \\ 1)
  def indent(nil, _), do: nil

  def indent(s, depth) when is_bitstring(s) do
    s
    |> String.trim()
    |> String.split("\n")
    # |> Enum.map_join("\n", &"#{String.duplicate("  ", depth)}#{&1}")
    |> Enum.map_join("\n", fn
      "" -> ""
      s -> "#{String.duplicate("  ", depth)}#{s}"
    end)
  end

  def concat(l, joiner \\ "\n") do
    l
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Enum.join(joiner)
  end

  def brackets(false), do: {"{", "}"}
  def brackets(true), do: {"<<", ">>"}

  def brackets(context, nil, false) do
    {"\\context #{context} {", "}"}
  end

  def brackets(context, nil, true) do
    {"\\context #{context} <<", ">>"}
  end

  def brackets(context, name, false) do
    {"\\context #{context} = \"#{name}\" {", "}"}
  end

  def brackets(context, name, true) do
    {"\\context #{context} = \"#{name}\" <<", ">>"}
  end
end
