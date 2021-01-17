defmodule NarouBot.Entity.Writer do
  use Ecto.Schema
  alias NarouBot.Entity.{User, Novel, UserCheckWriter}

  schema "writers" do
    has_many     :novels, Novel
    many_to_many :users,  User, join_through: UserCheckWriter

    field :remote_id,         :integer
    field :name,              :string,  null: false
    field :remote_deleted,    :boolean, default: false
    field :remote_deleted_at, :utc_datetime
    timestamps()
  end
end
