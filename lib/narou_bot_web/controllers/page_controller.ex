defmodule NarouBotWeb.PageController do
  use NarouBotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
