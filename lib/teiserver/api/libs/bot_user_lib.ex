defmodule Teiserver.API.BotUserLib do
  alias Teiserver.API.{BotUser, Permission}
  alias Teiserver.Repo
  alias Teiserver.Account.User
  alias Ecto.Changeset

  @spec get_bot_user(String.t()) :: BotUser.t() | nil
  def get_bot_user(secret) do
    Repo.get_by(BotUser, secret: secret)
  end

  @spec set_bot_user(map()) :: {:ok, struct} | {:error, %Ecto.changeset(){}}
  defp set_bot_user(%{secret: secret, name: _name, owner: _owner} = attrs) do
    case get_key(secret) do
      nil ->
        Key.changeset(%Key{}, attrs)
        |> Repo.insert()

      key ->
        key
        |> Key.changeset(attrs)
        |> Repo.update()
    end
  end

  @spec get_bot_user_permissions(BotUser.t()) :: [Permission.t()]
  def get_bot_user_permissions(%BotUser{} = bot_user) do
    bot_user
    |> Repo.preload(:permissions)
    |> Map.get(:permissions, [])
    |> Enum.map(& &1.name)
  end

  @spec add_bot_user_permission(BotUser.t(), [Permission.t()]) :: any
  def add_bot_user_permission(%BotUser{} = bot_user, permissions) when is_list(permissions) do
    bot_user = Repo.preload(bot_user, :permissions)

    existing_permissions = MapSet.new(Enum.map(bot_user.permissions, & &1.id))

    new_permissions =
      bot_user.permissions ++
        Enum.reject(permissions, fn p -> p.id in existing_permissions end)

    bot_user
    |> Changeset.change()
    |> Changeset.put_assoc(:permissions, new_permissions)
    |> Repo.update()
  end

  @spec remove_bot_user_permission(BotUser.t(), [Permissions.t()]) :: any
  def remove_bot_user_permission(%BotUser{} = bot_user, permissions) when is_list(permissions) do
    bot_user = Repo.preload(bot_user, :permissions)

    existing_permissions = MapSet.new(Enum.map(bot_user.permissions, & &1.id))

    remaining_permissions =
      Enum.reject(bot_user.permissions, fn p -> p.id in existing_permissions end)

    bot_user
    |> Changeset.change()
    |> Changeset.put_assoc(:permissions, remaining_permissions)
    |> Repo.update()
  end

  @spec new_bot_user(String.t(), User.t()) :: BotUser.t()
  def new_bot_user(name, creator) do
    secret = secure_random_secret()
    {:ok, bot_user} = set_bot_user(%{secret: secret, name: name, creator: creator})
    bot_user
  end

  @spec secure_random_secret() :: String.t()
  defp secure_random_secret() do
    :crypto.strong_rand_bytes(40)
    |> Base.url_encode64(padding: false)
    |> binary_part(0, 40)
  end
end
