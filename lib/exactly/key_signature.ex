defmodule Exactly.KeySignature do
  @moduledoc """
  Models a Lilypond key signature
  """

  alias Exactly.Pitch

  defstruct [:pitch, :mode]

  @valid_modes ~w(major minor dorian phrygian lydian mixolydian locrian ionian aeolian)a

  @type t :: %__MODULE__{
          pitch: Pitch.t(),
          mode:
            :major
            | :minor
            | :dorian
            | :phrygian
            | :lydian
            | :mixolydian
            | :locrian
            | :ionian
            | :aeolian
        }

  def new(%Pitch{} = pitch, mode \\ :major) do
    case validate_mode(mode) do
      {:ok, mode} ->
        %__MODULE__{
          pitch: pitch,
          mode: mode
        }

      :error ->
        {:error, :invalid_key_signature_mode, mode}
    end
  end

  defp validate_mode(mode) when mode in @valid_modes, do: {:ok, mode}
  defp validate_mode(_), do: :error

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(%@for{pitch: pitch, mode: mode}, _opts) do
      concat([
        "#Exactly.KeySignature<",
        to_string(pitch),
        " ",
        to_string(mode),
        ">"
      ])
    end
  end

  defimpl Exactly.ToLilypond do
    def to_lilypond(%@for{pitch: pitch, mode: mode}) do
      "\\key #{to_string(pitch)} \\#{to_string(mode)}"
    end
  end
end
