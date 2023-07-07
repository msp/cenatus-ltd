defmodule CenatusLtdWeb.NavView do
  use CenatusLtdWeb, :view

  def is_active?(:link, conn, link_name) do
    if action_name(conn) == link_name do
      "nav-link active"
    else
      ""
    end
  end

  def is_active?(:aria, conn, link_name) do
    if action_name(conn) == link_name do
      "page"
    else
      "false"
    end
  end
end
