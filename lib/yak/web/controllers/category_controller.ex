defmodule Yak.Web.CategoryController do
  
  use Yak.Web, :controller

  alias Yak.Board

  def show(conn, %{"permalink" => permalink}) do
    category = Board.get_category_with_jobs(permalink)
    render conn, :show, category: category
  end
end