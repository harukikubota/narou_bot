defmodule NarouBot.Repo.Migrations.AddFlagColToNovels do
  use Ecto.Migration

  def change do
    alter table(:novels) do
      add :finished,       :boolean, default: false
      add :is_short_story, :boolean, default: false
    end
  end
end
