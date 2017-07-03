defmodule Yak.Board.Notification do
  use Ecto.Schema

  schema "board_notifications" do
    belongs_to :job, Yak.Board.Job

    field :message_id, :string
    field :tag, :string
    field :submitted_at, :naive_datetime
    field :error_code, :integer
    field :message, :string
  end
end
