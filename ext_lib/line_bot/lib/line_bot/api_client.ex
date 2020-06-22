defmodule LineBot.APIClient do
  use HTTPoison.Base
  require Logger

  # HTTPoison
  ############

  @impl HTTPoison.Base
  @doc "Prepends the request url with `https://api.line.me/v2/bot/`."
  def process_request_url(url), do: super("https://api.line.me/v2/bot/" <> url)

  @impl HTTPoison.Base
  @doc """
  Adds the OAuth Bearer token to the `Authorization` header.
  The token is retrieved by calling `LineBot.TokenServer.get_token/0`.

  Also adds the `User-Agent` header with a value of `line-botsdk-elixir/vX.X.X`.
  This follows the pattern of Line Bot libraries in other languages.
  """
  def process_request_headers(headers) do
    [
      {"Authorization", "Bearer #{Application.fetch_env!(:line_bot, :client_id)}"},
      {"User-Agent", "line-botsdk-elixir/v#{Application.spec(:line_bot, :vsn)}"}
      | super(headers)
    ]
  end

  @impl HTTPoison.Base
  @doc """
  If the reponse headers indidate that the response is JSON, the response body is
  automatically decoded.
  """
  def process_response(%{headers: headers, body: body} = response) do
    Logger.debug("API Response: " <> inspect(response))

    case Enum.find(headers, &(String.downcase(elem(&1, 0)) == "content-type")) do
      {_, "application/json" <> _} -> put_in(response.body, Jason.decode!(body))
      _ -> super(response)
    end
  end

  @impl HTTPoison.Base
  @doc """
  Issues a POST request to the given url.
  The body is automatically encoded into JSON, and the `Content-Type` header is added.
  """
  def post(url, body, headers \\ []) do
    super(url, Jason.encode!(body), [{"Content-Type", "application/json"} | headers])
  end

  @impl HTTPoison.Base
  @doc """
  Issues a POST request to the given url.
  The body is automatically encoded into JSON, and the `Content-Type` header is added.
  """
  def post!(url, body, headers \\ []) do
    super(url, Jason.encode!(body), [{"Content-Type", "application/json"} | headers])
  end

  @impl HTTPoison.Base
  @doc """
  In addition to the `HTTPoison.request/5` behaviour, will automatically refresh the access
  token after an unauthorized request. Gives up after three subsequent unauthorized errors.
  """
  def request(method, url, body, headers, opts \\ []) do
    case super(method, url, body, headers, opts) do
      {:ok, %{status_code: 200} = response} ->
        {:ok, response}

      other ->
        other
    end
  end
end
