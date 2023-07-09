defmodule Exactly.StopTrillSpan do
  @moduledoc """
  Models the end of a trill span
  """

  use Exactly.Attachable, has_direction: false, priority: -1

  def new do
    %__MODULE__{
      components: [after: ["\\stopTrillSpan"]]
    }
  end
end
