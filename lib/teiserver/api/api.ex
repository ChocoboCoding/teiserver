defmodule Teiserver.API do
  alias Teiserver.API.{PermissionLib, KeyLib}

  @spec get_key(String.t()) :: Key.t() | nil
  defdelegate get_key(key), to: KeyLib

  @spec set_key(map()) :: any
  defdelegate set_key(attrs), to: KeyLib

  #  @spec get_permission(String.t()) :: Permission.t() | nil
  #  defdelegate get_permission(name), to: PermissionLib

  @spec get_module(String.t()) :: module() | nil
  defdelegate get_module(name), to: PermissionLib

  @spec set_permission(module()) :: any
  defdelegate set_permission(module), to: PermissionLib

  def register_api(module) do
    quote do
      set_permission(unquote(module))
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [__CALLER__.module])
  end
end
