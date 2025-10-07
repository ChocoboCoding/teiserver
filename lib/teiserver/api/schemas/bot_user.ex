defmodule Teiserver.API.BotUser do
  @moduledoc false
  use TeiserverWeb, :schema

  schema "bot_user" do
    field :name, :string, primary_key: true
    field :secret, :string

    many_to_many :permissions, Teiserver.API.Permission,
      join_through: "bot_user_permissions",
      join_keys: [bot_user_id: :name, permission_id: :name]

    belongs_to :creator, Teiserver.Account.User
  end

  def changeset(bot_user, attrs \\ %{}) do
    bot_user
    |> cast(attrs, [:name, :secret, :creator])
    |> validate_required([:secret, :name, :creator])
    |> put_assoc(:permissions, Map.get(attrs, :permissions, []))
  end
end
