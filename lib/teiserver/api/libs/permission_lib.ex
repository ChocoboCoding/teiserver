defmodule Teiserver.API.PermissionLib do
  alias Teiserver.API.Permission
  alias Teiserver.Repo

  @name_length 10

  @spec get_permission(String.t()) :: Permission.t() | nil
  defp get_permission(name) do
    Repo.get_by(Permission, name: name)
  end

  @spec get_module(String.t()) :: module() | nil
  def get_module(name) do
    permission = get_permission(name)
    String.to_existing_atom(permission.module)
  end

  @spec set_permission(module()) :: any
  def set_permission(module) do
    name = obfuscate_module(module)

    Repo.insert!(
      %Permission{
        name: name,
        module: Atom.to_string(module)
      },
      on_conflict: :replace_all,
      conflict_target: :module
    )
  end

  @spec delete_permission(String.t()) :: any
  def delete_permission(permission_name) do
    permission = Repo.get!(Permission, permission_name)
    Repo.delete(permission)
  end

  @spec obfuscate_module(module()) :: String.t()
  defp obfuscate_module(module) do
    module
    |> Atom.to_string()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
    |> binary_part(0, @name_length)
  end
end
