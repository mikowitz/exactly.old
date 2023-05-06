defmodule Exactly.Utils do
  @moduledoc false

  import Bitwise

  @float_bias 1022

  def frexp(value) do
    <<sign::1, exp::11, frac::52>> = <<value::float>>
    frexp(sign, frac, exp)
  end

  defp frexp(_sign, 0, 0) do
    {0, 0}
  end

  # Handle denormalised values
  defp frexp(sign, frac, 0) do
    exp = bitwise_length(frac)
    <<f::float>> = <<sign::1, @float_bias::11, frac - 1::52>>
    {f, -@float_bias - 52 + exp}
  end

  # Handle normalised values
  defp frexp(sign, frac, exp) do
    <<f::float>> = <<sign::1, @float_bias::11, frac::52>>
    {f, exp - @float_bias}
  end

  defp bitwise_length(value), do: bitwise_length(value, 0)
  defp bitwise_length(0, n), do: n
  defp bitwise_length(value, n), do: bitwise_length(value >>> 1, n + 1)
end
