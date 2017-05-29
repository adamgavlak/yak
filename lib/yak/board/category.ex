defmodule Yak.Board.Category do
  use Ecto.Schema

  schema "board_categories" do
    field :name, :string
    field :emoji, :string
    field :permalink, :string

    has_many :jobs, Yak.Board.Job

    timestamps()
  end
end
