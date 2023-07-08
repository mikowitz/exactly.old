defmodule Exactly.StopHairpin do
  @moduledoc """
  Models the end of a hairpin
  """

  use Exactly.Attachable, has_direction: false

  def new do
    %__MODULE__{
      components: [after: ["\\!"]]
    }
  end
end
