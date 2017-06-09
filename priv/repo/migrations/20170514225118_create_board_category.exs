defmodule Yak.Repo.Migrations.CreateYak.Board.Category do
  use Ecto.Migration

  def change do
    create table(:board_categories) do
      add :name, :string
      add :emoji, :string
      add :permalink, :string
      add :lokal, :string

      timestamps()
    end

    create index(:board_categories, [:permalink])
  end
end
