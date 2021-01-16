defmodule NarouBot.Repo.RichMenus do
  use NarouBot.Repo

  alias NarouBot.Entity.RichMenu

  def all, do: Repo.all(RichMenu)

  def find_by_name(menu_name), do: Repo.get_by(RichMenu, name: menu_name)

  def create(remote_id, name), do: %RichMenu{} |> Map.merge(%{remote_id: remote_id, name: name}) |> Repo.insert!

  def delete_all!, do: from(RichMenu) |> Repo.delete_all()
end
