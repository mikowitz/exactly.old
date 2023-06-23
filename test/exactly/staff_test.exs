defmodule Exactly.StaffTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Note, Pitch, Staff, Voice}

  describe "new/1" do
    test "takes a list of containable elements" do
      staff =
        Staff.new([
          Voice.new([
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ]),
          Note.new(Pitch.new(2), Duration.new(1 / 2))
        ])

      assert length(staff.elements) == 2
      assert staff.name == nil
      refute staff.simultaneous
    end
  end

  describe "new/2" do
    test "can take an optional name" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          "Staff One"
        )

      assert length(staff.elements) == 2
      assert staff.name == "Staff One"
      refute staff.simultaneous
    end
  end

  describe "new/3" do
    test "can set simultaneous via keyword opts" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          "Staff One",
          simultaneous: true
        )

      assert length(staff.elements) == 2
      assert staff.name == "Staff One"
      assert staff.simultaneous
    end

    test "must set nil name explicitly if using opts" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          nil,
          simultaneous: true
        )

      assert length(staff.elements) == 2
      assert is_nil(staff.name)
      assert staff.simultaneous
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation for an unnamed staff" do
      staff =
        Staff.new([
          Voice.new([
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ]),
          Note.new(Pitch.new(2), Duration.new(1 / 2))
        ])

      assert inspect(staff) == "#Exactly.Staff<{ 2 }>"
    end

    test "for a named staff" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          "Flutes"
        )

      assert inspect(staff) == "#Exactly.Staff<Flutes { 2 }>"
    end

    test "for a simultaneous staff" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          "Flutes",
          simultaneous: true
        )

      assert inspect(staff) == "#Exactly.Staff<Flutes << 2 >>>"
    end

    test "for an unnamed simultaneous staff" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          nil,
          simultaneous: true
        )

      assert inspect(staff) == "#Exactly.Staff<<< 2 >>>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for an unnamed staff" do
      staff =
        Staff.new([
          Voice.new([
            Note.new(Pitch.new(), Duration.new(1 / 4)),
            Note.new(Pitch.new(1), Duration.new(1 / 4))
          ]),
          Note.new(Pitch.new(2), Duration.new(1 / 2))
        ])

      assert Exactly.to_lilypond(staff) ==
               String.trim("""
               \\context Staff {
                 \\context Voice {
                   c4
                   d4
                 }
                 e2
               }
               """)
    end

    test "returns the correct Lilypond string for a named staff" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          "Flutes"
        )

      assert Exactly.to_lilypond(staff) ==
               String.trim("""
               \\context Staff = "Flutes" {
                 \\context Voice {
                   c4
                   d4
                 }
                 e2
               }
               """)
    end

    test "returns the correct Lilypond string for a simultaneous staff" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          "Flutes",
          simultaneous: true
        )

      assert Exactly.to_lilypond(staff) ==
               String.trim("""
               \\context Staff = "Flutes" <<
                 \\context Voice {
                   c4
                   d4
                 }
                 e2
               >>
               """)
    end

    test "returns the correct Lilypond string for an unnamed simultaneous staff" do
      staff =
        Staff.new(
          [
            Voice.new([
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(1), Duration.new(1 / 4))
            ]),
            Note.new(Pitch.new(2), Duration.new(1 / 2))
          ],
          nil,
          simultaneous: true
        )

      assert Exactly.to_lilypond(staff) ==
               String.trim("""
               \\context Staff <<
                 \\context Voice {
                   c4
                   d4
                 }
                 e2
               >>
               """)
    end
  end
end
