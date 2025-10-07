defmodule Teiserver.API.Permission do
  @moduledoc false
  use TeiserverWeb, :schema

  @type t :: %__MODULE__{
          name: String.t(),
          module: module()
        }

  schema "api_permissions" do
    field :name, :string, primary_key: true
    field :module, :string

    many_to_many :bot_users, Teiserver.API.BotUser,
      join_through: "bot_user_permissions",
      join_keys: [bot_user_id: :name, permission_id: :name]
  end

  def changeset(permission, attrs \\ %{}) do
    permission
    |> cast(attrs, [:name, :module])
    |> validate_required([:name, :module])
  end
end
