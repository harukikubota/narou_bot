defmodule NarouBot.Entity.Writer do
  use Ecto.Schema
  import Ecto.Changeset
  alias NarouBot.Entity.{User, Novel, UserCheckWriter}

  schema "writers" do
    field :remote_id, :integer
    field :name, :string, null: false
    field :remote_deleted, :boolean, default: false
    field :remote_deleted_at, :utc_datetime

    timestamps()

    has_many :novels, Novel
    many_to_many :users, User, join_through: UserCheckWriter
  end
end
