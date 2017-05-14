defmodule Wework.Repo.Migrations.CreateWework.Board.Category do
  use Ecto.Migration

  def change do
    create table(:board_categories) do
      add :name, :string
      add :permalink, :string

      timestamps()
    end

  end
end
