defprotocol Exactly.ToLilypond do
  def to_lilypond(x)
end

defimpl Exactly.ToLilypond, for: Atom do
  def to_lilypond(nil), do: nil
  def to_lilypond(atom), do: to_string(atom)
end
