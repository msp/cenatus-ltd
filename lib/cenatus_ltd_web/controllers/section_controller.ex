defmodule CenatusLtdWeb.SectionController do
  use CenatusLtdWeb, :controller

  alias CenatusLtdWeb.Section

  def index(conn, _params) do
    sections =
      Repo.all(Section)
      |> Repo.preload(:articles)

    render(conn, "index.html", sections: sections)
  end

  def new(conn, _params) do
    changeset = Section.changeset(%Section{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"section" => section_params}) do
    changeset = Section.changeset(%Section{}, section_params)

    case Repo.insert(changeset) do
      {:ok, _section} ->
        conn
        |> put_flash(:info, "Section created successfully.")
        |> redirect(to: Routes.section_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)
    render(conn, "show.html", section: section)
  end

  def edit(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)
    changeset = Section.changeset(section)
    render(conn, "edit.html", section: section, changeset: changeset)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Repo.get!(Section, id)
    changeset = Section.changeset(section, section_params)

    case Repo.update(changeset) do
      {:ok, section} ->
        conn
        |> put_flash(:info, "Section updated successfully.")
        |> redirect(to: Routes.section_path(conn, :show, section))

      {:error, changeset} ->
        render(conn, "edit.html", section: section, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(section)

    conn
    |> put_flash(:info, "Section deleted successfully.")
    |> redirect(to: Routes.section_path(conn, :index))
  end
end
