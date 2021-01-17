defmodule NarouBot.Repo do
  use Ecto.Repo, otp_app: :narou_bot, adapter: Ecto.Adapters.Postgres

  defmacro __using__(_) do
    quote do
      use NarouBot, :repo
    end
  end

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
