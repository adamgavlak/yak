defmodule Wework.Board.Job do
  use Ecto.Schema

  schema "board_jobs" do
    field :title, :string
    belongs_to :category, Wework.Board.Category

    field :location, :string
    field :description, :string
    field :description_formatted, :string
    field :instructions, :string

    field :company, :string
    field :logo, :string
    field :url, :string
    field :email, :string

    field :highlight, :boolean, default: false

    field :status, :integer
    field :note, :string
    field :token, :string

    timestamps()
  end
end
