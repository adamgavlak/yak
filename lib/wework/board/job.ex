defmodule Wework.Board.Job do
  use Ecto.Schema

  @primary_key {:id, Wework.Type.Permalink, autogenerate: true}
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

    field :status, Wework.Type.Status, default: :waiting
    field :note, :string
    field :token, Wework.Type.Token, autogenerate: true

    timestamps()
  end
end

defimpl Phoenix.Param, for: Wework.Board.Job do
  def to_param(%{id: id, title: title}) do
    "#{Wework.Hashids.encode(id)}"
  end
end