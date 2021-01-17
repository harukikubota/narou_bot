defmodule NarouBot.Repo.UsersCheckWriters do
  use NarouBot.Repo

  alias Repo.Users
  alias NarouBot.Entity.UserCheckWriter

  def registered?(user_id, writer_id) do
    from(
      UserCheckWriter,
      where: [
        user_id: ^user_id, writer_id: ^writer_id
      ]
    )
    |> first()
    |> Repo.one()
    |> if(do: true, else: false)
  end

  def user_register_count(user_id) do
    from(
      uc in UserCheckWriter,
      where: uc.user_id == ^user_id,
      select: count()
    )
    |> Repo.one
  end

  def link_to(user_id, writer_id) do
    UserCheckWriter.changeset(%UserCheckWriter{}, %{user_id: user_id, writer_id: writer_id})
    |> Repo.insert!
  end

  def unlink_to(user_id, writer_id) do
    from(
      UserCheckWriter,
      where: [
        user_id: ^user_id,
        writer_id: ^writer_id]
    )
    |> Repo.delete_all
  end

  def unlink_all(writer_id) do
    users = Users.notification_target_users :delete_writer, writer_id: writer_id

    Enum.each(users, &unlink_to(&1, writer_id))
    users
  end
end
