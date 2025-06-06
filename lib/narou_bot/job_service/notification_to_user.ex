defmodule NarouBot.JobService.NotificationToUser do
  alias NarouBot.Repo.{
    NotificationFacts
  }
  alias NarouBot.Template.JobService.Notificate_data, as: Template
  alias NarouBot.JobService.JobControlActivity
  require Logger

  def exec do
    if JobControlActivity.job_activity? do
      :timer.sleep 30000
      Logger.info "start job NotificationToUser"

      update_records_not_to_be_notified()

      notification_facts()
      |> update_all_to_job_touch
      |> allocate_to_each_user
      |> Enum.each(&notification_to_user/1)

      Logger.info "end job NotificationToUser"
    else
      Logger.info "from NotificationToUser: job stopped."
    end
  end

  defp update_records_not_to_be_notified do
    NotificationFacts.change_notification_off_novel_update_record_to_unread()
  end

  defp notification_facts, do: NotificationFacts.inserted_records()

  defp update_all_to_job_touch(records) do
    case records do
      [] -> Logger.info "通知データなし"
      _  -> Logger.info "通知データ #{length(records)}件"
    end
    NotificationFacts.change_status_all(records, :job_touch)
    records
  end

  defp allocate_to_each_user(records) do
    Enum.group_by(records, &(&1.user_id))
    |> Enum.map(fn {_, v} -> v end)
  end

  def notification_to_user(records) do
    user_id = hd(records).user.line_id

    case LineBot.send_push(user_id, render_message(records)) do
      {:ok, _}    -> NotificationFacts.change_status_all(records, :notificated)
      {_, reason} -> NotificationFacts.change_status_all(records, :error, reason)
    end
  end

  defp render_message(records), do: Template.render(:ok, records)
end
