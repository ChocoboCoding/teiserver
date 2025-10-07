defmodule Teiserver.API.ControllerRegistry do
  alias Teiserver.Repo
  alias Teiserver.API.Permission
  alias Teiserver.API.PermissionLib

  def register(module) when is_atom(module) do
    PermissionLib.set_permission(module)
  end
end
