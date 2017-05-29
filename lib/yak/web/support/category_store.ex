defmodule Yak.Board.Category.Store do
  use GenServer

  require Logger

  @refresh_after :timer.minutes(60)
  
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def list do
    GenServer.call(__MODULE__, :list)
  end

  ## Server

  def init(_) do
    categories = Yak.Board.list_categories()
    schedule_refresh()

    {:ok, categories}
  end

  def handle_call(:list, _from, categories) do
    {:reply, categories, categories}
  end

  def handle_info(:refresh, categories) do
    Logger.info "Refreshing category store"
    categories = Yak.Board.list_categories()
    schedule_refresh()
    {:noreply, categories}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_after)
  end
end