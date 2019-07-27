defmodule CenatusLtd.SectionTest do
  use CenatusLtd.ModelCase

  alias CenatusLtd.Section

  @valid_attrs %{name: "Blog"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Section.changeset(%Section{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Section.changeset(%Section{}, @invalid_attrs)
    refute changeset.valid?
  end
end
