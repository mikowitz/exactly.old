defmodule Exactly.ContainerTest do
  use ExUnit.Case, async: true

  alias Exactly.{Container, Note}

  describe "new/1" do
    test "takes a list of containable elements" do
      container = Container.new([Note.new()])

      assert length(container.elements) == 1
      refute container.simultaneous
    end
  end

  describe "new/2" do
    test "can set simultaneous via keyword opts" do
      container = Container.new([Note.new()], simultaneous: true)

      assert length(container.elements) == 1
      assert container.simultaneous
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation for a container" do
      container = Container.new([Note.new()])

      assert inspect(container) == "#Exactly.Container<{ 1 }>"
    end

    test "returns an IEx-ready represenation for a simultaneous container" do
      container = Container.new([Note.new()], simultaneous: true)

      assert inspect(container) == "#Exactly.Container<<< 1 >>>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for a container" do
      container = Container.new([Note.new()])

      assert Exactly.to_lilypond(container) ==
               String.trim("""
               {
                 c'4
               }
               """)
    end

    test "returns the correct Lilypond string for a simultaneous container" do
      container = Container.new([Note.new()], simultaneous: true)

      assert Exactly.to_lilypond(container) ==
               String.trim("""
               <<
                 c'4
               >>
               """)
    end
  end
end
