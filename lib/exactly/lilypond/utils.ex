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
    |> Enum.map(fn {k, v} -> {k, Enum.sort_by(v, &elem(&1, 2))} end)
    |> Enum.map(fn {k, as} -> {k, indent_attachments(as, k)} end)
    |> Enum.into(%{})
  end

  defp indent_attachments(attachments, :before) do
    Enum.map(attachments, &elem(&1, 0))
  end

  defp indent_attachments(attachments, :after) do
    Enum.map(attachments, fn {attachment, should_indent, _} ->
      if should_indent, do: indent(attachment), else: attachment
    end)
  end
end
