defmodule Teiserver.Api.PermissionLib do
  alias Teiserver.Api.Permission

  @spec get_permission(String.t()) :: Permission.t() | nil
  def get_permission(name) do
    Repo.get_by(Permission, name: name)
  end

  @spec set_permission(String.t(), module()) :: any
  def set_permission(name, module) do
    case get_permission(name) do
      nil ->
        Permission.changeset(%Permission{}, %{name: name, module: module})
        |> Repo.insert()

      permission ->
        permission
        |> Permission.changeset(%{module: module})
        |> Repo.update()
    end
  end
end
