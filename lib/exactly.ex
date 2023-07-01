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

  defmacro container(do: do_block) do
    elements =
      case do_block do
        {:__block__, _, els} -> Enum.map(els, &process_element/1)
        el -> [el]
      end

    quote do
      Exactly.Container.new([unquote_splicing(elements)])
    end
  end

  defmacro book(do: do_block) do
    with elements <- extract_elements(do_block),
         {output_name, elements} <- extract_output_name(elements),
         {output_suffix, elements} <- extract_output_suffix(elements) do
      quote do
        Exactly.Book.new([unquote_splicing(elements)],
          output_suffix: unquote(output_suffix),
          output_name: unquote(output_name)
        )
      end
    end
  end

  defp extract_elements({:__block__, _, els}), do: Enum.map(els, &process_element/1)
  defp extract_elements(el), do: [process_element(el)]

  defp extract_output_name(elements) do
    case Enum.find(elements, fn
           {:output_name, _, _} -> true
           _ -> false
         end) do
      {:output_name, _, [name]} = el -> {name, List.delete(elements, el)}
      nil -> {nil, elements}
    end
  end

  defp extract_output_suffix(elements) do
    case Enum.find(elements, fn
           {:output_suffix, _, _} -> true
           _ -> false
         end) do
      {:output_suffix, _, [suffix]} = el -> {suffix, List.delete(elements, el)}
      nil -> {nil, elements}
    end
  end

  def process_element(el), do: el
end
