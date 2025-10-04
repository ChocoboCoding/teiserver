defmodule Teiserver.API.Key do
  @moduledoc false
  use TeiserverWeb, :schema

  schema "api_keys" do
    field :key, :string, primary_key: true
    field :name, :string
    field :description, :string

    many_to_many :permissions, Teiserver.API.Permission,
      join_through: "api_keys_permissions",
      join_keys: [api_key_id: :key, permission_id: :name]

    belongs_to :owner, Teiserver.Account.User
  end

  def changeset(api_key, attrs \\ %{}) do
    api_key
    |> cast(attrs, [:key, :name, :description, :owner_id])
    |> validate_required([:key, :name, :owner_id])
    |> put_assoc(:permissions, Map.get(attrs, :permissions, []))
  end
end
