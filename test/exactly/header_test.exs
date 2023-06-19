defmodule Exactly.HeaderTest do
  use ExUnit.Case, async: true

  alias Exactly.Header

  describe "new/0" do
    test "creates an emepty header block" do
      assert Header.new() == %Header{settings: []}
    end
  end

  describe "new/1" do
    test "takes an initializing keyword list of settings" do
      header = Header.new(title: "Hello", composer: "Michael")

      assert Enum.sort(header.settings) == [composer: "Michael", title: "Hello"]
    end
  end

  describe "set/2" do
    test "merges a keyword list into existing settings" do
      header = Header.new()
      header = Header.set(header, tagline: false)

      assert header == %Header{
               settings: [tagline: false]
             }
    end

    test "overwrites an existing key" do
      header = Header.new(composer: "Michael")
      header = Header.set(header, tagline: false, composer: "Michael Berkowitz")

      assert Enum.sort(header.settings) == [composer: "Michael Berkowitz", tagline: false]
    end
  end

  describe "delete/2" do
    test "deletes the setting for the given key if it exists" do
      header = Header.new(composer: "Michael", tagline: false)
      header = Header.delete(header, :tagline)

      assert header.settings == [composer: "Michael"]
    end

    test "leaves the header unchanged if the key does not exist" do
      header = Header.new(composer: "Michael", tagline: false)
      header = Header.delete(header, :subtitle)

      assert Enum.sort(header.settings) == [composer: "Michael", tagline: false]
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation of the header block" do
      header = Header.new(title: "Hello", composer: "Michael")

      assert inspect(header) == "#Exactly.Header<composer=\"Michael\" title=\"Hello\">"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for the duration" do
      header = Header.new(title: "Hello", composer: "Michael", tagline: false)

      assert Exactly.to_lilypond(header) ==
               String.trim("""
               \\header {
                 composer = "Michael"
                 tagline = ##f
                 title = "Hello"
               }
               """)
    end
  end
end
