defmodule NarouBot.Entity.RichMenu do
  use Ecto.Schema

  schema "rich_menus" do
    field :remote_id, :string
    field :name,      :string
  end
end
