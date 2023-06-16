defmodule Exactly.Inspect do
  @moduledoc false

  def brackets(simultaneous), do: brackets(nil, simultaneous)

  def brackets(nil, false), do: {"{", "}"}
  def brackets(nil, true), do: {"<<", ">>"}
  def brackets(name, false), do: {"#{name} {", "}"}
  def brackets(name, true), do: {"#{name} <<", ">>"}
end
