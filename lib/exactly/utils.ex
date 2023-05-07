defmodule Exactly.Utils do
  @moduledoc false

  import Bitwise

  @float_bias 1022

  def to_fraction(alpha, max_denominator \\ 1024) do
    a = 0
    b = 1
    c = 1
    d = 0
    gamma = alpha

    {a, b, as, bs} = to_fraction(a, b, c, d, gamma, max_denominator)

    if bs >= max_denominator do
      {a, b}
    else
      {as, bs}
    end
  end

  defp to_fraction(a, b, c, d, gamma, max_denominator) do
    s = floor(gamma)
    as = a + s * c
    bs = b + s * d

    a = c
    b = d
    c = as
    d = bs

    if gamma != s && bs <= max_denominator do
      gamma = 1 / (gamma - s)
      to_fraction(a, b, c, d, gamma, max_denominator)
    else
      {a, b, c, d}
    end
  end

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
