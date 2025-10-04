defmodule Teiserver.API.KeyLib do
  alias Teiserver.API.Key

  @spec get_key(String.t()) :: Key.t() | nil
  def get_key(key) do
    Repo.get_by(Key, key: key)
  end

  @spec set_key(map()) :: any
  def set_key(%{key: key, name: name, owner: owner} = attrs) do
    case get_key(key) do
      nil ->
        Key.changeset(%Key{}, attrs)
        |> Repo.insert()

      key ->
        key
        |> Key.changeset(attrs)
        |> Repo.update()
    end
  end
end
