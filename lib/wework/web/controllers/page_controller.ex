defmodule Wework.Web.PageController do
  use Wework.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
