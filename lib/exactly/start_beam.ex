defmodule Exactly.StartBeam do
  @moduledoc """
  Models the beginning of a specified beam
  """

  use Exactly.Attachable

  def new do
    %__MODULE__{
      components: [after: ["["]]
    }
  end
end
