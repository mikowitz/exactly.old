defmodule Exactly.StopBeam do
  @moduledoc """
  Models the end of a specified beam
  """

  use Exactly.Attachable, has_direction: false

  def new do
    %__MODULE__{
      components: [after: ["]"]]
    }
  end
end
