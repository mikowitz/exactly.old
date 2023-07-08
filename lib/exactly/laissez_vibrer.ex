defmodule Exactly.LaissezVibrer do
  @moduledoc """
  Models a laissez vibrer tie
  """

  use Exactly.Attachable

  def new do
    %__MODULE__{
      components: [after: ["\\laissezVibrer"]]
    }
  end
end
