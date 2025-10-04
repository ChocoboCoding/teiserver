defmodule Teiserver.API.PermissionLib do
  alias Teiserver.API.Permission

  @name_length 10

  @spec get_permission(String.t()) :: Permission.t() | nil
  def get_permission(name) do
    Repo.get_by(Permission, name: name)
  end

  @spec get_module(String.t()) :: module() | nil
  def get_module(name) do
    permission = get_permission(name)
    permission.module
  end

  @spec set_permission(String.t(), module()) :: any
  def set_permission(module) do
    name = obfuscate_module(module)

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

  @spec obfuscate_module(module()) :: any
  defp obfuscate_module(module) do
    module
    |> Atom.to_string()
    |> :crypto.hash(:sha256)
    |> Base.encode16(case: :lower)
    |> binary_part(0, @name_length)
  end
end
