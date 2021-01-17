defmodule NarouBot.Entity.NovelEpisode do
  use Ecto.Schema
  alias NarouBot.Entity.Novel

  schema "novel_episodes" do
    belongs_to :novel, Novel

    field :episode_id,        :integer
    field :remote_created_at, :utc_datetime
    field :remote_deleted_at, :utc_datetime
    field :remote_deleted,    :boolean, default: false
    timestamps()
  end
end
