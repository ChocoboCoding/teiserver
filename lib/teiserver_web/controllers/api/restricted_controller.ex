defmodule TeiserverWeb.API.RestrictedController do
  use TeiserverWeb, :controller

  alias Teiserver.API.PermissionLib
  TeiserverWeb.API.SpadsView

  @spec call_api(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call_api(conn, %{"name" => name} = params) do
    module = PermissionLib.get_module(name)
    module.call(conn, params)
  end
end
