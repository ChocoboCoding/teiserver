defmodule TeiserverWeb.API.RestrictedController do
  use TeiserverWeb, :controller

  alias Teiserver.API.PermissionLib
  TeiserverWeb.API.SpadsView

  @spec call_api(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call_api(conn, %{"name" => name} = params) do
    case PermissionLib.get_module(name) do
      nil ->
        conn
        |> put_status(404)
        |> render("empty.json")

      module ->
        module.call(conn, params)
    end
  end
end
