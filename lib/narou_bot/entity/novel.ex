defmodule NarouBot.Entity.Novel do
  use Ecto.Schema
  import Ecto.Changeset
  alias NarouBot.Entity.{User, NovelEpisode, Writer, UserCheckNovel}

  schema "novels" do
    belongs_to   :writer,       Writer
    has_one      :last_episode, NovelEpisode
    has_one      :check_user,   UserCheckNovel
    has_many     :episodes,     NovelEpisode
    many_to_many :users,        User, join_through: UserCheckNovel

    field :ncode,             :string
    field :title,             :string
    field :finished,          :boolean, default: false
    field :is_short_story,    :boolean, default: false
    field :remote_deleted,    :boolean, default: false
    field :remote_deleted_at, :utc_datetime
    timestamps()
  end

  def changeset(novel, attrs) do
    novel
    |> cast(attrs, [:ncode, :title])
    |> validate_required([:ncode, :title])
    |> validate_length(:title, min: 2)
    |> validate_format(:ncode, Narou.Util.ncode_format())
    |> unique_constraint(:ncode)
  end

  def changeset(:remote_deleted, novel, attrs) do
    novel
    |> cast(attrs, [:remote_deleted, :remote_deleted_at])
    |> validate_required([:remote_deleted, :remote_deleted_at])
  end

  def conv_is_short_story(novel_type) do
    case novel_type do
      2 -> true
      1 -> false
      _ -> raise "Unexpected value. novel_type: #{novel_type}"
    end
  end

  def conv_finished(end_val) do
    case end_val do
      0 -> true
      1 -> false
      _ -> raise "Unexpected value. end: #{end_val}"
    end
  end

  @doc """
      更新確認対象か？
  """
  @spec is_subject_to_update_check(%__MODULE__{}) :: boolean()
  def is_subject_to_update_check(self) do
    self.finished
  end
end
