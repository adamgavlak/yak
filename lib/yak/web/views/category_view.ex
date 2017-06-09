defmodule Yak.Web.CategoryView do
  use Yak.Web, :view
  require Logger

  def title("show.html", assigns) do
    assigns.category.name
  end

  def title(_, _assigns), do: ""
end