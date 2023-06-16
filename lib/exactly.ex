defmodule Exactly do
  @moduledoc """
  ExactLy provides a procedural, programmatic way to build up a Lilypond score
  using Elixir as the building blocks.
  """

  use Exactly.Lilypond.Executable

  @type score_element ::
          Exactly.Chord.t()
          | Exactly.Container.t()
          | Exactly.Note.t()
          | Exactly.Rest.t()
          | Exactly.Score.t()
          | Exactly.Skip.t()
          | Exactly.Staff.t()
          | Exactly.StaffGroup.t()
          | Exactly.Tuplet.t()
          | Exactly.Voice.t()

  alias Exactly.Lilypond.File, as: LilypondFile

  def to_lilypond(x), do: Exactly.ToLilypond.to_lilypond(x)

  def show(element) do
    element
    |> LilypondFile.from()
    |> LilypondFile.save()
    |> LilypondFile.compile()
    |> LilypondFile.show()
  end
end
