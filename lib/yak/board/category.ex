defmodule Yak.Board.Category do
  use Ecto.Schema

  schema "board_categories" do
    field :name, :string
    field :permalink, :string
    field :lokal, :string

    has_many :jobs, Yak.Board.Job
    field :job_count, :integer, virtual: true, default: 0

    timestamps()
  end
end
