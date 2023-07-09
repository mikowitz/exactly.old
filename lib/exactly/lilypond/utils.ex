defmodule Exactly.Lilypond.Utils do
  @moduledoc false

  alias Exactly.Attachment

  def indent(s, depth \\ 1)
  def indent(nil, _), do: nil

  def indent(s, depth) when is_bitstring(s) do
    s
    |> String.trim()
    |> String.split("\n")
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

  def attachments_for(%{attachments: attachments}) do
    attachments
    |> Enum.reverse()
    |> Enum.map(&Attachment.prepared_components/1)
    |> Enum.reduce([before: [], after: []], fn components, acc ->
      Keyword.merge(acc, components, fn _k, v1, v2 -> v1 ++ v2 end)
    end)
    |> Enum.into(%{})
    |> update_in([:after], fn as ->
      Enum.map(as, fn
        {attachment, true} -> indent(attachment)
        {attachment, false} -> attachment
      end)
    end)
  end
end
