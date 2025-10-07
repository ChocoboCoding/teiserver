defmodule Teiserver.Repo.Migrations.AddKeyAndPermissionTable do
  use Ecto.Migration

  def change do
    create table(:bot_users, primary_key: false) do
      add :name, :string, null: false, primary_key: true
      add :secret, :string
      add :creator_id, references(:account_users)

      timestamps()
    end

    create table(:api_permissions, primary_key: false) do
      add :name, :string, primary_key: true
      add :module, :string, null: false

      timestamps()
    end

    create table(:bot_user_permissions) do
      add :bot_user_id, references(:bot_users, type: :string, on_delete: :delete_all)
      add :permission_id, references(:api_permissions, type: :string, on_delete: :deleta_all)
    end

    create unique_index(:bot_user_permissions, [:bot_user_id, :permission_id])
  end
end
