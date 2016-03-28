defmodule BlogEngine.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :author, :string

      timestamps
    end

  end
end
