defmodule Exactly.Barline do
  @moduledoc """
  Models a lilypond barline
  """

  @valid_barlines ~w(| . || .| |. .. |.| ; ! ' , .|: :|. :..: :|.|: :|.: :.|.: [|: :|] :|][|:)

  defstruct [:barline]

  @type t :: %__MODULE__{
          barline: String.t()
        }

  def new(barline \\ "|") do
    case validate_barline(barline) do
      {:ok, barline} -> %__MODULE__{barline: barline}
      :error -> {:error, :invalid_barline, barline}
    end
  end

  defp validate_barline(barline) when barline in @valid_barlines or barline == "",
    do: {:ok, barline}

  defp validate_barline(_), do: :error

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{barline: barline}, opts) do
      concat([
        "#Exactly.Barline<",
        @protocol.inspect(barline, opts),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%@for{barline: barline}) do
      "\\bar \"#{barline}\""
    end
  end
end
