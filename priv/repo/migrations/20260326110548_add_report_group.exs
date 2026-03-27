defmodule Teiserver.Repo.Migrations.AddReportGroup do
  use Ecto.Migration

  def change do
    alter table(:moderation_reports) do
      add :report_group_id, :integer
    end

    create table(:moderation_repor_groups) do
      add :match_id, :integer
      add :action_report_message_id, :integer
      add :chat_report_message_id, :integer
    end
  end
end
