defmodule Exactly.AttachmentTest do
  use ExUnit.Case, async: true

  alias Exactly.{Articulation, Attachment}

  describe "new/1" do
    test "creates a new attachment with the given attachable and default settings" do
      articulation = Articulation.new(:accent)
      attachment = Attachment.new(articulation)

      assert attachment.attachable == articulation
      assert attachment.priority == 0
      assert attachment.direction == :neutral
    end
  end

  describe "new/2" do
    test "can override priority and direction" do
      articulation = Articulation.new(:accent)
      attachment = Attachment.new(articulation, priority: 1, direction: :up)

      assert attachment.attachable == articulation
      assert attachment.priority == 1
      assert attachment.direction == :up
    end
  end
end
