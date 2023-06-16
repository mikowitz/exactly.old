defmodule Exactly.Lilypond.Utils do
  @moduledoc false

  def indent(s) do
    s
    |> String.split("\n", trim: true)
    |> Enum.map_join("\n", &"  #{&1}")
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
