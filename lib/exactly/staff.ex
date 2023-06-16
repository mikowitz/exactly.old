defmodule Exactly.Staff do
  @moduledoc """
  Models a Lilypond staff context
  """

  defstruct [:elements, :name, :simultaneous]

  def new(elements \\ [], name \\ nil, opts \\ []) do
    %__MODULE__{
      elements: elements,
      name: name,
      simultaneous: Keyword.get(opts, :simultaneous, false)
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{elements: elements, name: name, simultaneous: simultaneous}, _opts) do
      {open, close} = brackets(name, simultaneous)

      concat([
        "#Exactly.Staff<",
        open,
        " #{length(elements)} ",
        close,
        ">"
      ])
    end

    defp brackets(nil, false), do: {"{", "}"}
    defp brackets(nil, true), do: {"<<", ">>"}
    defp brackets(name, false), do: {"#{name} {", "}"}
    defp brackets(name, true), do: {"#{name} <<", ">>"}
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{elements: elements, name: name, simultaneous: simultaneous}) do
      {open, close} = brackets(name, simultaneous)

      [
        open,
        Enum.map(elements, fn el ->
          el |> @protocol.to_lilypond() |> indent()
        end),
        close
      ]
      |> List.flatten()
      |> Enum.join("\n")
    end

    defp brackets(nil, false), do: {"\\context Staff {", "}"}
    defp brackets(nil, true), do: {"\\context Staff <<", ">>"}
    defp brackets(name, false), do: {"\\context Staff = \"#{name}\" {", "}"}
    defp brackets(name, true), do: {"\\context Staff = \"#{name}\" <<", ">>"}
  end
end
