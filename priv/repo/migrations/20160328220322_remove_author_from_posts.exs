defmodule BlogEngine.Repo.Migrations.RemoveAuthorFromPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
        remove :author
    end
  end
end
