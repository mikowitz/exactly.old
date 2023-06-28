defmodule Exactly.Header do
  @moduledoc """
  Models the header block for a Lilypond score
  """

  defstruct [:settings]

  @type t :: %__MODULE__{
          settings: Keyword.t()
        }

  def new(settings \\ []) do
    %__MODULE__{settings: settings}
  end

  def set(%__MODULE__{settings: settings} = header, new_settings \\ []) do
    %{header | settings: Keyword.merge(settings, new_settings)}
  end

  def delete(%__MODULE__{settings: settings} = header, key) do
    %{header | settings: Keyword.delete(settings, key)}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{settings: settings}, _opts) do
      concat([
        "#Exactly.Header<",
        "#{format_settings(settings)}",
        ">"
      ])
    end

    def format_settings(settings) do
      settings
      |> Enum.sort()
      |> Enum.map_join(" ", fn {k, v} -> "#{k}=\"#{v}\"" end)
    end
  end

  defimpl Exactly.ToLilypond do
    import Exactly.Lilypond.Utils

    def to_lilypond(%@for{settings: settings}) do
      [
        "\\header {",
        format_settings(settings),
        "}"
      ]
      |> concat()
    end

    defp format_settings(settings) do
      settings
      |> Enum.sort()
      |> Enum.map(fn setting -> setting |> format_setting() |> indent() end)
    end

    defp format_setting({k, v}) when is_boolean(v) do
      case v do
        true -> "#{k} = ##t"
        false -> "#{k} = ##f"
      end
    end

    defp format_setting({k, v}), do: "#{k} = \"#{v}\""
  end
end
