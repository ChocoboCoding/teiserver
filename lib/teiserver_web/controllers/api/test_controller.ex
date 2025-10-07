defmodule TeiserverWeb.API.Protected.TestController do
  use Teiserver.API, :register
  alias Teiserver.{Moderation, Repo, Account}
  alias Teiserver.API.BotUserLib

  def call(conn, _params) do
    report = Moderation.get_report!(1)
    report = Repo.preload(report, [:reporter, :target])

    conn
    |> put_status(200)
    |> render("test.json",
      reporter: report.reporter,
      target: report.target,
      id: report.id
    )
  end

  def generate_user(conn, _params) do
    user = Account.get_user(1)
    bot_user = BotUserLib.new_bot_user("test_user", user)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{token: bot_user.secret}))
    |> halt()
  end
end
