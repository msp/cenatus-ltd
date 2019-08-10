defmodule CenatusLtdWeb.UserTest do
  use CenatusLtdWeb.ModelCase

  alias CenatusLtdWeb.User

  @valid_attrs %{name: "test-user", username: "test-username", password: "passw0rd"}
  @invalid_attrs %{}

  describe "default changeset: " do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "registration changeset: " do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
