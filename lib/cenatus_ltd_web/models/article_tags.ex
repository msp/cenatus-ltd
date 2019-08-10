defmodule CenatusLtdWeb.ArticleTags do
  use CenatusLtdWeb, :model

  schema "article_tags" do
    belongs_to(:article, CenatusLtdWeb.Article)
    belongs_to(:tags, CenatusLtdWeb.Tag)
    timestamps()
  end
end
