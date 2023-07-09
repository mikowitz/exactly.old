defmodule Exactly.StartSlur do
  @moduledoc """
  Models the beginning of a slur
  """

  use Exactly.Attachable, priority: 1

  def new do
    %__MODULE__{
      components: [after: ["("]]
    }
  end
end
