defmodule Exactly.StartPhrasingSlur do
  @moduledoc """
  Models the beginning of a phrasing slur
  """

  use Exactly.Attachable

  def new do
    %__MODULE__{
      components: [after: ["\\("]]
    }
  end
end
