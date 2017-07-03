defmodule Yak.Worker.ViewCount do
  use Toniq.Worker

  def perform(job) do
    Yak.Board.increment_views(job)
  end
end