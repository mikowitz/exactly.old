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

  defimpl Inspect do
    def inspect(%@for{}, _opts), do: "#Exactly.LaissezVibrer<>"
  end
end
