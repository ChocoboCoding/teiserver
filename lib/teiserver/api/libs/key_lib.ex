defmodule Teiserver.API.KeyLib do
  alias Teiserver.API.Key
  alias Teiserver.Repo

  @spec get_key(String.t()) :: Key.t() | nil
  def get_key(key) do
    Repo.get_by(Key, key: key)
  end

  @spec set_key(map()) :: any
  def set_key(%{key: key, name: _name, owner: _owner} = attrs) do
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
