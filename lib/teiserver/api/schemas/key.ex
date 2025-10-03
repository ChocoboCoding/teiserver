defmodule Teiserver.Api.Key do
  @moduledoc false
  use TeiserverWeb, :schema

  schema "api_keys" do
    field :key, :string, primary_key: true
    field :name, :string
    field :description, :string

    has_many :permissions, Teiserver.Api.Permission
    belongs_to :owner, Teiserver.Account.User
  end

  def changeset(permission, attrs \\ %{}) do
    permission
    |> cast(attrs, ~w(key name owner))
    |> validate_required([:key, :name, :owner])
  end
end
