defmodule Exactly.Barline do
  @moduledoc """
  Models a lilypond barline
  """

  @valid_barlines ~w(| . || .| |. .. |.| ; ! ' , .|: :|. :..: :|.|: :|.: :.|.: [|: :|] :|][|:)

  use Exactly.Attachable, has_direction: false, fields: [:barline], should_indent: false

  @type t :: %__MODULE__{
          barline: String.t(),
          components: Keyword.t()
        }

  def new(barline \\ "|") do
    case validate_barline(barline) do
      {:ok, barline} ->
        %__MODULE__{
          barline: barline,
          components: [
            after: ["\\bar \"#{barline}\""]
          ]
        }

      :error ->
        {:error, :invalid_barline, barline}
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
end
