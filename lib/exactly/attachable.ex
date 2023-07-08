defmodule Exactly.Attachable do
  @moduledoc """
  Shared functionality for attachable objects

    * articulations
    * clefs
    * time signatures
    * key signatures
    * slurs
    * beams
    * dynamics
    * etc.
  """

  defmacro __using__(opts) do
    fields = Keyword.get(opts, :fields, [])
    has_direction = Keyword.get(opts, :has_direction, true)

    quote do
      defstruct [unquote_splicing(fields), :components]

      defimpl Exactly.HasDirection do
        def has_direction(_), do: unquote(has_direction)
      end

      if unquote(fields) == [] do
        defimpl Inspect do
          def inspect(%@for{}, _opts) do
            module_name = Module.split(@for) |> Enum.join(".")
            "##{module_name}<>"
          end
        end
      end
    end
  end
end
