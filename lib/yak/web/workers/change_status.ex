defmodule Yak.Worker.ChangeStatus do
  use Toniq.Worker

  alias Yak.Board

  def perform(job: job, status: status) do
    Board.change_job_status(job, status)
  end
end