defmodule CenatusLtdWeb.SharedFormattersTest do
  use ExUnit.Case, async: true

  alias CenatusLtdWeb.SharedFormatters

  describe "linkify/1" do
    test "converts a URL to a link with domain text" do
      assert SharedFormatters.linkify("Check https://example.com/page out") ==
               "Check <a href=\"https://example.com/page\" target=\"_blank\">example.com</a> out"
    end

    test "handles text with no URLs" do
      assert SharedFormatters.linkify("no links here") == "no links here"
    end

    test "handles multiple URLs" do
      input = "See https://foo.com and https://bar.org/path"

      result = SharedFormatters.linkify(input)

      assert result =~ "<a href=\"https://foo.com\" target=\"_blank\">foo.com</a>"
      assert result =~ "<a href=\"https://bar.org/path\" target=\"_blank\">bar.org</a>"
    end

    test "handles http URLs" do
      assert SharedFormatters.linkify("visit http://example.com") ==
               "visit <a href=\"http://example.com\" target=\"_blank\">example.com</a>"
    end

    test "handles URLs with paths and query strings" do
      input = "link https://example.com/path?q=1&r=2 here"

      result = SharedFormatters.linkify(input)

      assert result =~
               "<a href=\"https://example.com/path?q=1&amp;r=2\" target=\"_blank\">example.com</a>"
    end

    test "HTML-escapes surrounding text" do
      assert SharedFormatters.linkify("<script>alert('xss')</script>") ==
               "&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;"
    end

    test "handles URL at start of text" do
      assert SharedFormatters.linkify("https://example.com is great") ==
               "<a href=\"https://example.com\" target=\"_blank\">example.com</a> is great"
    end

    test "handles URL at end of text" do
      assert SharedFormatters.linkify("visit https://example.com") ==
               "visit <a href=\"https://example.com\" target=\"_blank\">example.com</a>"
    end

    test "handles URL as entire text" do
      assert SharedFormatters.linkify("https://example.com") ==
               "<a href=\"https://example.com\" target=\"_blank\">example.com</a>"
    end

    test "handles empty string" do
      assert SharedFormatters.linkify("") == ""
    end

    test "preserves subdomains in display" do
      assert SharedFormatters.linkify("https://blog.example.com/post") ==
               "<a href=\"https://blog.example.com/post\" target=\"_blank\">blog.example.com</a>"
    end
  end
end
