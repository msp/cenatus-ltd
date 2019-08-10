defmodule CenatusLtdWeb.TestHelpers do
  alias CenatusLtd.Repo
  alias CenatusLtdWeb.Article

  def insert_article(attrs \\ %{}) do
    changes =
      Map.merge(
        %{
          "title" => "default title",
          "summary" => "default summary",
          "content" => "default content",
          "published_at" => DateTime.utc_now(),
          "tags" => ""
        },
        attrs
      )

    Article.changeset(%Article{}, changes)
    |> Repo.insert!()
  end
end
