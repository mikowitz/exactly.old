defmodule Exactly.LilypondLiteral do
  @moduledoc """
  Allows attaching Lilypond command strings directly to score objects
  """

  use Exactly.Attachable,
    fields: [:literal, :location],
    has_direction: false,
    should_indent: false

  def new(literal, opts \\ []) do
    location = opts[:location] || :before

    %__MODULE__{
      location: location,
      literal: literal
    }
    |> build_components()
  end

  defp build_components(%__MODULE__{location: location, literal: literal} = lilypond_literal) do
    components = [{location, List.flatten([literal])}]

    %{
      lilypond_literal
      | components: components
    }
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{literal: literal}, _opts) do
      concat([
        "#Exactly.LilypondLiteral<",
        inspect_literal(literal),
        ">"
      ])
    end

    defp inspect_literal(l) when is_list(l) do
      "\n" <> Enum.map_join(List.wrap(l), "\n", &"  #{&1}") <> "\n"
    end

    defp inspect_literal(l), do: to_string(l)
  end
end
