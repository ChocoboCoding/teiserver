defmodule Teiserver.API.JWTAuthPlug do
  import Plug.Conn
  alias Teiserver.API.JWTAuthLib

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- JWTAuthLib.verify_jwt(token),
         true <- route_allowed?(conn.request_path, claims) do
      assign(conn, :jwt_claims, claims)
    else
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> halt()

        {:error}

      false ->
        conn
        |> put_status(403)
        |> halt()
    end
  end

  defp route_allowed?(conn, %{"permissions" => permissions}) when is_list(permissions) do
    route_name = conn.params["name"]
    Enum.member?(permissions, route_name)
  end

  defp route_allowed?(_, _), do: false
end
