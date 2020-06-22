defmodule NarouBot.Entity.NovelEpisode do
  use Ecto.Schema
  import Ecto.Changeset
  alias NarouBot.Entity.Novel

  schema "novel_episodes" do
    field :episode_id,        :integer
    field :remote_created_at, :utc_datetime
    field :remote_deleted_at, :utc_datetime
    field :remote_deleted,    :boolean, default: false

    timestamps()

    belongs_to :novel, Novel
  end
end
