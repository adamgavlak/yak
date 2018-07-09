defmodule Yak.Web.JobView do
  use Yak.Web, :view

  def title("show.html", assigns) do
    assigns.job.title <> " - " <> assigns.job.company
  end

  def title("new.html", _assigns) do
    "Nová ponuka práce"
  end

  def title("edit.html", _assigns) do
    "Úprava ponuky práce"
  end

  def title("preview.html", _assigns) do
    "Náhľad ponuky práce"
  end

  def title(_, _assigns), do: "Všetky ponuky"
end
