defmodule Teiserver.API.JWTAuthLib do
  alias Teiserver.API.BotUserLib

  @secret "secret"
  @expiration_time_seconds 5 * 60

  defp signer, do: Joken.Signer.create("HS256", @secret)

  def generate_jwt(bot_user_secret) do
    bot_user = BotUserLib.get_bot_user(bot_user_secret)
    permissions = BotUserLib.get_bot_user_permissions(bot_user)

    claims = %{
      "sub" => bot_user.name,
      "exp" => Joken.current_time() + @expiration_time_seconds,
      "iat" => Joken.current_time(),
      "permissions" => permissions
    }

    {:ok, token, _claims} = Joken.generate_and_sign!(claims, signer())
    token
  end

  def verify_jwt(token) when is_binary(token) do
    case Joken.verify(token, signer()) do
      {:ok, claims} ->
        if claims.exp < Joken.current_time() do
          {:ok, claims}
        else
          {:error, :expired}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
