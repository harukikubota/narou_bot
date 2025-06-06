defmodule NarouBot.Entity.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias NarouBot.Entity.{
    Novel,
    Writer,
    UserCheckNovel,
    UserCheckWriter,
    NotificationInfo
  }

  schema "users" do
    has_many     :notification_facts, NotificationInfo
    many_to_many :novels,             Novel,  join_through: UserCheckNovel
    many_to_many :writers,            Writer, join_through: UserCheckWriter

    field :line_id,             :string,  null: false
    field :enabled,             :boolean, default: true
    field :novel_register_max,  :integer, default: 50
    field :writer_register_max, :integer, default: 50
  end

  def changeset(user, attr \\ %{}) do
    user
    |> cast(attr, [:line_id, :enabled])
    |> validate_required([:line_id])
    |> unique_constraint(:line_id)
  end
end
