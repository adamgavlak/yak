defmodule Yak.Worker.Index do
  use Toniq.Worker

  alias Yak.Board
  alias Yak.Board.Job
  import Yak.Web.Router.Helpers

  def perform(conn: conn, job: %Job{} = job) do
    Algolia.save_object("dev_JOBS", 
      %{objectID: job.id,
        title: job.title,
        company: job.company,
        location: job.location,
        link: job_url(conn, :show, job)}
    )
  end
end