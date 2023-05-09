defmodule Exactly do
  @moduledoc """
  ExactLy provides a procedural, programmatic way to build up a Lilypond score
  using Elixir as the building blocks.
  """

  @type score_element ::
          Exactly.Chord.t()
          | Exactly.Note.t()
          | Exactly.Rest.t()
          | Exactly.Skip.t()
          | Exactly.Tuplet.t()
          | Exactly.Voice.t()

  def to_lilypond(x), do: Exactly.ToLilypond.to_lilypond(x)
end
