defmodule CenatusLtd.SubstackNotesTest do
  use ExUnit.Case, async: true

  alias CenatusLtd.SubstackNotes

  @valid_item %{
    "comment" => %{
      "body" => "Hello from Substack",
      "date" => "2026-01-21T10:33:30.003Z",
      "id" => 202862243,
      "handle" => "mattspendlove",
      "name" => "Matt Spendlove"
    }
  }

  @valid_json Jason.encode!(%{"items" => [@valid_item]})

  describe "parse_response/1" do
    test "parses valid JSON with notes" do
      [note] = SubstackNotes.parse_response(@valid_json)

      assert note.type == :note
      assert note.title == "Hello from Substack"
      assert note.link == "https://substack.com/@mattspendlove/note/c-202862243"
      assert note.date == ~N[2026-01-21 10:33:30]
    end

    test "returns [] for invalid JSON" do
      assert SubstackNotes.parse_response("not json") == []
    end

    test "returns [] for empty string" do
      assert SubstackNotes.parse_response("") == []
    end

    test "returns [] for nil" do
      assert SubstackNotes.parse_response(nil) == []
    end

    test "returns [] for non-string input" do
      assert SubstackNotes.parse_response(42) == []
      assert SubstackNotes.parse_response(%{}) == []
    end
  end

  describe "parse_json/1" do
    test "returns [] when top-level key is not 'items'" do
      assert SubstackNotes.parse_json(%{"data" => []}) == []
    end

    test "returns [] when 'items' is not a list" do
      assert SubstackNotes.parse_json(%{"items" => "oops"}) == []
    end

    test "returns [] for empty items list" do
      assert SubstackNotes.parse_json(%{"items" => []}) == []
    end

    test "returns [] for completely unexpected structure" do
      assert SubstackNotes.parse_json("a string") == []
      assert SubstackNotes.parse_json(nil) == []
      assert SubstackNotes.parse_json(123) == []
    end

    test "skips items without a comment key" do
      items = [%{"post" => %{"title" => "An article"}}, @valid_item]
      result = SubstackNotes.parse_json(%{"items" => items})
      assert length(result) == 1
    end

    test "skips items where comment has no body" do
      bad_item = %{"comment" => %{"date" => "2026-01-01T00:00:00Z", "id" => 1, "handle" => "x"}}
      result = SubstackNotes.parse_json(%{"items" => [bad_item]})
      assert result == []
    end
  end

  describe "parse_item/1" do
    test "parses a valid item" do
      note = SubstackNotes.parse_item(@valid_item)

      assert note.type == :note
      assert note.title == "Hello from Substack"
      assert note.date == ~N[2026-01-21 10:33:30]
      assert note.link =~ "mattspendlove"
      assert note.description == nil
    end

    test "returns nil when body is missing" do
      item = put_in(@valid_item, ["comment", "body"], nil)
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil when body is not a string" do
      item = put_in(@valid_item, ["comment", "body"], 123)
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil when date is missing" do
      item = %{"comment" => Map.delete(@valid_item["comment"], "date")}
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil when date is unparseable" do
      item = put_in(@valid_item, ["comment", "date"], "not-a-date")
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil when id is missing" do
      item = %{"comment" => Map.delete(@valid_item["comment"], "id")}
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil when handle is missing" do
      item = %{"comment" => Map.delete(@valid_item["comment"], "handle")}
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil when handle is not a string" do
      item = put_in(@valid_item, ["comment", "handle"], 999)
      assert SubstackNotes.parse_item(item) == nil
    end

    test "returns nil for item without comment key" do
      assert SubstackNotes.parse_item(%{"post" => %{}}) == nil
    end

    test "returns nil for non-map input" do
      assert SubstackNotes.parse_item("string") == nil
      assert SubstackNotes.parse_item(nil) == nil
    end

    test "trims whitespace from body" do
      item = put_in(@valid_item, ["comment", "body"], "  padded text  ")
      note = SubstackNotes.parse_item(item)
      assert note.title == "padded text"
    end

    test "linkifies URLs in title_html" do
      item = put_in(@valid_item, ["comment", "body"], "Check https://example.com out")
      note = SubstackNotes.parse_item(item)
      assert note.title == "Check https://example.com out"
      assert note.title_html =~ "<a href"
      assert note.title_html =~ "example.com</a>"
    end

    test "handles integer id in link" do
      note = SubstackNotes.parse_item(@valid_item)
      assert note.link == "https://substack.com/@mattspendlove/note/c-202862243"
    end

    test "handles string id in link" do
      item = put_in(@valid_item, ["comment", "id"], "12345")
      note = SubstackNotes.parse_item(item)
      assert note.link == "https://substack.com/@mattspendlove/note/c-12345"
    end
  end

  describe "parse_iso_date/1" do
    test "parses valid ISO 8601 date" do
      assert SubstackNotes.parse_iso_date("2026-01-21T10:33:30.003Z") ==
               ~N[2026-01-21 10:33:30]
    end

    test "returns nil for invalid date string" do
      assert SubstackNotes.parse_iso_date("not-a-date") == nil
    end

    test "returns nil for empty string" do
      assert SubstackNotes.parse_iso_date("") == nil
    end

    test "returns nil for nil" do
      assert SubstackNotes.parse_iso_date(nil) == nil
    end

    test "returns nil for non-string" do
      assert SubstackNotes.parse_iso_date(42) == nil
    end

    test "truncates to seconds" do
      result = SubstackNotes.parse_iso_date("2026-06-15T14:30:45.999Z")
      assert result == ~N[2026-06-15 14:30:45]
    end
  end

  describe "end-to-end resilience" do
    test "completely different JSON structure returns []" do
      json = Jason.encode!(%{"results" => [%{"text" => "hello"}]})
      assert SubstackNotes.parse_response(json) == []
    end

    test "items with changed field names returns []" do
      json = Jason.encode!(%{
        "items" => [%{
          "note" => %{
            "content" => "Hello",
            "created_at" => "2026-01-01T00:00:00Z",
            "note_id" => 123,
            "author_handle" => "someone"
          }
        }]
      })
      assert SubstackNotes.parse_response(json) == []
    end

    test "HTML in body is escaped" do
      item = put_in(@valid_item, ["comment", "body"], "<b>bold</b> & stuff")
      note = SubstackNotes.parse_item(item)
      assert note.title_html =~ "&lt;b&gt;"
      assert note.title_html =~ "&amp;"
    end

    test "valid items survive alongside malformed ones" do
      bad_item = %{"comment" => %{"body" => "no other fields"}}
      json = Jason.encode!(%{"items" => [bad_item, @valid_item, %{"garbage" => true}]})
      result = SubstackNotes.parse_response(json)
      assert length(result) == 1
      assert hd(result).title == "Hello from Substack"
    end
  end
end
