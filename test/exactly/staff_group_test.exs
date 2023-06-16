defmodule Exactly.StaffGroupTest do
  use ExUnit.Case, async: true

  alias Exactly.{Duration, Note, Pitch, Staff, StaffGroup}

  describe "new/1" do
    test "takes a list of containable elements" do
      staff_group =
        StaffGroup.new([
          Staff.new(
            [
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
            ],
            "Violin"
          ),
          Staff.new(
            [
              Note.new(Pitch.new(2), Duration.new(1 / 4)),
              Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
            ],
            "Violin"
          )
        ])

      assert length(staff_group.elements) == 2
      assert staff_group.name == nil
      assert staff_group.simultaneous
    end
  end

  describe "new/2" do
    test "can take an optional name" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Violin"
            )
          ],
          "Strings"
        )

      assert length(staff_group.elements) == 2
      assert staff_group.name == "Strings"
      assert staff_group.simultaneous
    end
  end

  describe "new/3" do
    test "can set simultaneous via keyword opts" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Violin"
            )
          ],
          "Strings",
          simultaneous: false
        )

      assert length(staff_group.elements) == 2
      assert staff_group.name == "Strings"
      refute staff_group.simultaneous
    end

    test "must set nil name explicitly if using opts" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Violin"
            )
          ],
          nil,
          simultaneous: false
        )

      assert length(staff_group.elements) == 2
      assert staff_group.name == nil
      refute staff_group.simultaneous
    end
  end

  describe "inspect/1" do
    test "returns an IEx-ready represenation for an unnamed staff group" do
      staff_group =
        StaffGroup.new([
          Staff.new(
            [
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
            ],
            "Violin"
          ),
          Staff.new(
            [
              Note.new(Pitch.new(2), Duration.new(1 / 4)),
              Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
            ],
            "Violin"
          )
        ])

      assert inspect(staff_group) == "#Exactly.StaffGroup<<< 2 >>>"
    end

    test "for a named staff group" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Violin"
            )
          ],
          "Strings"
        )

      assert inspect(staff_group) == "#Exactly.StaffGroup<Strings << 2 >>>"
    end

    test "for a non-simultaneous staff" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Violin"
            )
          ],
          "Strings",
          simultaneous: false
        )

      assert inspect(staff_group) == "#Exactly.StaffGroup<Strings { 2 }>"
    end

    test "for an unnamed non-simultaneous staff" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Violin"
            )
          ],
          nil,
          simultaneous: false
        )

      assert inspect(staff_group) == "#Exactly.StaffGroup<{ 2 }>"
    end
  end

  describe "to_lilypond/1" do
    test "returns the correct Lilypond string for an unnamed staff group" do
      staff_group =
        StaffGroup.new([
          Staff.new(
            [
              Note.new(Pitch.new(), Duration.new(1 / 4)),
              Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
            ],
            "Violin"
          ),
          Staff.new(
            [
              Note.new(Pitch.new(2), Duration.new(1 / 4)),
              Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
            ],
            "Viola"
          )
        ])

      assert Exactly.to_lilypond(staff_group) ==
               String.trim("""
               \\context StaffGroup <<
                 \\context Staff = "Violin" {
                   c'4
                   cs'4
                 }
                 \\context Staff = "Viola" {
                   e'4
                   fqf'4
                 }
               >>
               """)
    end

    test "returns the correct Lilypond string for a named staff group" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Viola"
            )
          ],
          "Strings"
        )

      assert Exactly.to_lilypond(staff_group) ==
               String.trim("""
               \\context StaffGroup = "Strings" <<
                 \\context Staff = "Violin" {
                   c'4
                   cs'4
                 }
                 \\context Staff = "Viola" {
                   e'4
                   fqf'4
                 }
               >>
               """)
    end

    test "returns the correct Lilypond string for a non-simultaneous staff group" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Viola"
            )
          ],
          "Strings",
          simultaneous: false
        )

      assert Exactly.to_lilypond(staff_group) ==
               String.trim("""
               \\context StaffGroup = "Strings" {
                 \\context Staff = "Violin" {
                   c'4
                   cs'4
                 }
                 \\context Staff = "Viola" {
                   e'4
                   fqf'4
                 }
               }
               """)
    end

    test "returns the correct Lilypond string for an unnamed non-simultaneous staff group" do
      staff_group =
        StaffGroup.new(
          [
            Staff.new(
              [
                Note.new(Pitch.new(), Duration.new(1 / 4)),
                Note.new(Pitch.new(0, 0.5), Duration.new(1 / 4))
              ],
              "Violin"
            ),
            Staff.new(
              [
                Note.new(Pitch.new(2), Duration.new(1 / 4)),
                Note.new(Pitch.new(3, -0.25), Duration.new(1 / 4))
              ],
              "Viola"
            )
          ],
          nil,
          simultaneous: false
        )

      assert Exactly.to_lilypond(staff_group) ==
               String.trim("""
               \\context StaffGroup {
                 \\context Staff = "Violin" {
                   c'4
                   cs'4
                 }
                 \\context Staff = "Viola" {
                   e'4
                   fqf'4
                 }
               }
               """)
    end
  end
end
