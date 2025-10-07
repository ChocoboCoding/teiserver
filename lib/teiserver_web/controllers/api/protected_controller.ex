defmodule TeiserverWeb.API.ProtectedController do
  use TeiserverWeb, :controller
  alias Teiserver.API.{PermissionLib, JWTAuthLib}

  @header_name "x-api-secret"

  @spec call_api(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call_api(conn, %{"name" => name} = params) do
    case PermissionLib.get_module(name) do
      nil ->
        conn
        |> put_status(404)
        |> halt()

      module ->
        module.call(conn, params)
    end
  end

  @spec generate_jwt(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def generate_jwt(conn, _params) do
    case get_req_header(conn, @header_name) do
      [secret] ->
        token = JWTAuthLib.generate_jwt(secret)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{token: token}))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: "Missing secret header"}))
    end
  end
end
