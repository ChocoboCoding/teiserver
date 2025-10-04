defmodule Teiserver.Repo.Migrations.AddKeyAndPermissionTable do
  use Ecto.Migration

  def change do
    create table(:api_keys, primary_key: false) do
      add :key, :string, primary_key: true
      add :name, :string, null: false
      add :description, :string
      add :owner_id, references(:account_users)

      timestamps()
    end

    create table(:api_permissions, primary_key: false) do
      add :name, :string, primary_key: true
      add :module, :string, null: false

      timestamps()
    end

    create table(:api_keys_permissions) do
      add :api_key_id, references(:api_keys, type: :string, on_delete: :delete_all)
      add :permission_id, references(:api_permissions, type: :string, on_delete: :deleta_all)
    end

    create unique_index(:api_keys_permissions, [:api_key_id, :permission_id])
  end
end
