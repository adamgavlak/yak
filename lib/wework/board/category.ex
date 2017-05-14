defmodule Wework.Board.Category do
  use Ecto.Schema

  schema "board_categories" do
    field :name, :string
    field :permalink, :string

    has_many :jobs, Wework.Board.Job

    timestamps()
  end
end
