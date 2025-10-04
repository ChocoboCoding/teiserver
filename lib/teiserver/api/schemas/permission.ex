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

    many_to_many :permissions, Teiserver.API.Permission,
      join_through: "api_keys_permissions",
      join_keys: [permission_id: :name, api_key_id: :key]
  end

  def changeset(permission, attrs \\ %{}) do
    permission
    |> cast(attrs, [:name, :module])
    |> validate_required([:name, :module])
  end
end
