defmodule Exactly.Tie do
  @moduledoc """
  Models a tie
  """

  use Exactly.Attachable

  def new do
    %__MODULE__{
      components: [after: ["~"]]
    }
  end
end
