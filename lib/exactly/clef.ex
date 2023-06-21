defmodule Exactly.Clef do
  @moduledoc """
  Models a lilypond clef
  """

  @valid_clefs ~w(G G2 treble violin french GG tenorG soprano mezzosoprano C alto tenor baritone varC altovarC tenorvarC baritonevarC varbaritone baritonevarF F bass subbass)a

  defstruct [:name, :octavation, :octavation_optional]

  @type t :: %__MODULE__{
          name: atom(),
          octavation: integer(),
          octavation_optional: nil | :parentheses | :brackets
        }

  def new(name, opts \\ []) do
    case validate_clef_name(name) do
      {:ok, name} ->
        %__MODULE__{
          name: name,
          octavation: Keyword.get(opts, :octavation, 0),
          octavation_optional: Keyword.get(opts, :octavation_optional, nil)
        }

      :error ->
        {:error, :invalid_clef_name, name}
    end
  end

  defp validate_clef_name(name) when name in @valid_clefs, do: {:ok, name}
  defp validate_clef_name(_), do: :error

  defimpl String.Chars do
    def to_string(%@for{name: name, octavation: octavation, octavation_optional: optional}) do
      "#{name}#{octavation_to_string(octavation, optional)}"
    end

    defp octavation_to_string(0, _), do: ""

    defp octavation_to_string(octavation, octavation_optional) do
      {open, close} = optional_wrapper(octavation_optional)
      directional_prefix = if octavation < 0, do: "_", else: "^"
      [directional_prefix, open, abs(octavation), close] |> Enum.join("")
    end

    defp optional_wrapper(nil), do: {"", ""}
    defp optional_wrapper(:parentheses), do: {"(", ")"}
    defp optional_wrapper(:brackets), do: {"[", "]"}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{} = clef, _opts) do
      concat([
        "#Exactly.Clef<",
        to_string(clef),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%@for{} = clef) do
      "\\clef \"#{to_string(clef)}\""
    end
  end
end
