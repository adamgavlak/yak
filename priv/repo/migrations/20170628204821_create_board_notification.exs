defmodule Yak.Repo.Migrations.CreateYak.Board.Notification do
  use Ecto.Migration

  def change do
    create table(:board_notifications) do
      add :job_id, references(:board_jobs, on_delete: :nothing)
      add :message_id, :string
      add :tag, :string
      add :submitted_at, :naive_datetime
      add :error_code, :integer
      add :message, :string
    end

    create index(:board_notifications, [:job_id])
  end
end
