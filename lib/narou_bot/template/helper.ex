defmodule NarouBot.Template.Helper do
  def format_date_yymmddhhmi(date) do
    date = NaiveDateTime.add(date, 3600 * 9)

    year = date.year |> to_string() |> String.split_at(2) |> elem(1)
    date =
      [y: year, m: date.month, d: date.day, h: date.hour, mi: date.minute]
      |> Enum.map(fn {k, v} -> {k, String.pad_leading(to_string(v), 2, "0")} end)
      |> Map.new

    "#{date.y}/#{date.m}/#{date.d} #{date.h}:#{date.mi}"
  end

  def postback_data(map) do
    action = Map.fetch!(map, :action)

    unless Regex.match?(~r/^\/?[a-z_\/]+[a-z]+$/, action), do: raise "actionの引数が無効 /path/to/action"

    in_name =
      [Mix.Project.config[:app] |> Atom.to_string, "command"] ++ (action |> String.split("/") |> Enum.reject(&(&1 == "")))
      |> Enum.map(&Macro.camelize/1)
      |> Module.concat

    {:module, _} = Code.ensure_loaded(in_name)
    unless function_exported?(in_name, :call, 1), do: raise "Commandではないです。 #{in_name}"

    map |> Enum.map(fn {k,v} -> "#{k}=#{v}" end) |> Enum.join("&")
  end

  def add_opt_open_url_link(url), do: url <> "?openExternalBrowser=1"

  def truncate_str(target, remaining_range \\ 0..20) do
    String.slice(target, remaining_range)
  end
end
