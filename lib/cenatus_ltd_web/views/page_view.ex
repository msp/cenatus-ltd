defmodule CenatusLtdWeb.PageView do
  use CenatusLtdWeb, :view

  def handler_info(conn) do
    action_name(conn)
  end
end
