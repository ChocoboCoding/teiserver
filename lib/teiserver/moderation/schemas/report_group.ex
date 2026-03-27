defmodule Teiserver.Moderation.ReportGroup do
  @moduledoc false
  use TeiserverWeb, :schema

  typed_schema "moderation_report_group" do
    belongs_to :match, Teiserver.Battle.Match

    field :action_report_message_id, :integer
    field :chat_report_message_id, :integer

    has_many :reports, Teiserver.Moderation.Report

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(
      params,
      ~w(match_id)a
    )
    |> validate_required(~w(match_id)a)
  end

  @spec authorize(atom(), Plug.Conn.t(), map()) :: bool()
  def authorize(:index, conn, _params), do: allow?(conn, "Overwatch")
  def authorize(:search, conn, _params), do: allow?(conn, "Overwatch")
  def authorize(:show, conn, _params), do: allow?(conn, "Overwatch")
  def authorize(:user, conn, _params), do: allow?(conn, "Overwatch")
  def authorize(:respond, conn, _params), do: allow?(conn, "Overwatch")
  def authorize(_action, conn, _params), do: allow?(conn, "Moderator")
end
