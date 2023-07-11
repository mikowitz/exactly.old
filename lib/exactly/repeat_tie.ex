defmodule Exactly.RepeatTie do
  @moduledoc """
  Models a repeat tie
  """

  use Exactly.Attachable

  def new do
    %__MODULE__{
      components: [after: ["\\repeatTie"]]
    }
  end
end
