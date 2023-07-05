defprotocol Exactly.HasDirection do
  @fallback_to_any true
  def has_direction(obj)
end

defimpl Exactly.HasDirection, for: Any do
  def has_direction(_), do: true
end
