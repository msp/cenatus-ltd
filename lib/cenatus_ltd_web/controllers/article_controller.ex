defmodule CenatusLtdWeb.ArticleController do
  use CenatusLtdWeb, :controller

  alias CenatusLtdWeb.{Article, Category, Section}

  plug(CenatusLtdWeb.LoadAllCategories)

  def index(conn, _params) do
    articles =
      Repo.all(Article)
      |> Repo.preload(:tags)
      |> Repo.preload(:tech_tags)

    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})

    sections =
      Repo.all(Section)
      |> Enum.map(fn s -> {s.name, s.id} end)

    categories =
      Repo.all(Category)
      |> Enum.map(fn c -> {c.name, c.id} end)

    render(conn, "new.html",
      changeset: changeset,
      tags: [],
      tech_tags: [],
      sections: sections,
      categories: categories
    )
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    sections =
      Repo.all(Section)
      |> Enum.map(fn s -> {s.name, s.id} end)

    case Repo.insert(changeset) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: Routes.article_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          sections: sections,
          tags: taglist_from(changeset.changes.tags),
          tech_tags: taglist_from(changeset.changes.tech_tags)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    main_article =
      Repo.get!(Article, id)
      |> Repo.preload(:tags)
      |> Repo.preload(:tech_tags)

    tag_ids = Enum.map(main_article.tags, fn t -> t.id end)
    tech_tag_ids = Enum.map(main_article.tech_tags, fn t -> t.id end)

    tags_query =
      from(article in Article,
        join: tag in assoc(article, :tags),
        where: tag.id in ^tag_ids,
        distinct: article.title
      )

    tech_tags_query =
      from(article in Article,
        join: tag in assoc(article, :tech_tags),
        where: tag.id in ^tech_tag_ids,
        distinct: article.title
      )

    candidates = Repo.all(tags_query) ++ Repo.all(tech_tags_query)

    related_articles =
      if candidates do
        Enum.reject(candidates, fn a -> a.id == main_article.id end)
        |> Enum.uniq_by(fn c -> c.id end)
        |> Enum.take(10)
      else
        []
      end

    render(conn, "show.html", article: main_article, related: related_articles)
  end

  def edit(conn, %{"id" => id}) do
    article =
      Repo.get!(Article, id)
      |> Repo.preload(:section)
      |> Repo.preload(:tags)
      |> Repo.preload(:tech_tags)

    sections =
      Repo.all(Section)
      |> Enum.map(fn s -> {s.name, s.id} end)

    categories =
      Repo.all(Category)
      |> Enum.map(fn c -> {c.name, c.id} end)

    changeset = Article.changeset(article)

    render(conn, "edit.html",
      article: article,
      sections: sections,
      categories: categories,
      msp: [1, 2, 3],
      changeset: changeset,
      tags: taglist_from(article.tags),
      tech_tags: taglist_from(article.tech_tags)
    )
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article =
      Repo.get!(Article, id)
      |> Repo.preload(:tags)
      |> Repo.preload(:tech_tags)

    changeset = Article.changeset(article, article_params)

    sections =
      Repo.all(Section)
      |> Enum.map(fn s -> {s.name, s.id} end)

    case Repo.update(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, changeset} ->
        render(conn, "edit.html",
          article: article,
          sections: sections,
          changeset: changeset,
          tags: taglist_from(article.tags),
          tech_tags: taglist_from(article.tech_tags)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: Routes.article_path(conn, :index))
  end

  defp taglist_from(tags) do
    Enum.map(tags, fn tag -> tag.name end)
    |> Enum.join(", ")
  end
end
