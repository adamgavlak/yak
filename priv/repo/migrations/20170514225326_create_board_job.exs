defmodule Yak.Repo.Migrations.CreateYak.Board.Job do
  use Ecto.Migration

  def change do
    create table(:board_jobs) do
      add :title, :string
      add :category_id, references(:board_categories, on_delete: :nothing)

      add :location, :string
      add :description, :text
      add :description_formatted, :text
      add :instructions, :string

      add :company, :string
      add :logo, :string
      add :url, :string
      add :email, :string

      add :highlight, :boolean, null: false, default: false

      add :status, :integer
      add :note, :string
      add :token, :uuid
      add :views, :integer, null: false, default: 0

      timestamps()
    end

    create index(:board_jobs, [:category_id])
    create index(:board_jobs, [:token])
  end
end
