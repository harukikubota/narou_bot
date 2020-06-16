defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias NarouBot.Repo
    end
  end

  def controller do
    quote do
      alias NarouBot
      import NarouBotWeb.Router.Helpers

      @endpoint NarouBotWeb.Endpoint
    end
  end

  def view do
    quote do
      import NarouBotWeb.Router.Helpers
    end
  end

  def channel do
    quote do
      alias NarouBot.Repo

      @endpoint NarouBotWeb.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
