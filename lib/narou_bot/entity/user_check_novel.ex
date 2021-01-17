defmodule NarouBot.Entity.UserCheckNovel do
  use Ecto.Schema
  import Ecto.Changeset
  alias NarouBot.Entity.{User, Novel}

  @primary_key false
  schema "users_check_novels" do
    belongs_to :user,  User
    belongs_to :novel, Novel

    field      :type,                     :string
    field      :do_notify,                :boolean
    field      :restart_episode_id,       :integer
    field      :turn_off_notification_at, :utc_datetime
    timestamps()
  end

  def ch_update_notify(struct, params) do
    struct
    |> cast(params, [:user_id, :novel_id, :type])
    |> validate_required([:user_id, :novel_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:novel_id)
    |> set_type("update_notify")
  end

  def ch_read_later(struct, params) do
    struct
    |> cast(params, [:user_id, :novel_id, :restart_episode_id, :type])
    |> validate_required([:user_id, :novel_id, :restart_episode_id])
    |> validate_number(:restart_episode_id, greater_than: 0)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:novel_id)
    |> set_type("read_later")
  end

  def set_type(ch, type) do
    put_change(ch, :type, type)
  end
end
