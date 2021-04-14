defmodule NarouBot.Repo.AdminInfo do
  use NarouBot.Repo
  import Ecto.Query

  def record_counts do
    Enum.map(targets(), &(count_query(&1) |> Repo.one()))
    |> Enum.reduce(&Kernel.+/2)
  end

  defp count_query(entity), do: from(entity, select: count("*"))

  defp targets do
    Enum.map(:code.all_loaded(), &Atom.to_string(elem(&1, 0)))
    |> Enum.filter(&Regex.match?(~r/^Elixir\.NarouBot\.Entity\.[\w]+$/, &1))
    |> Enum.reject(&(&1 in reject_modules()))
    |> Enum.map(&Module.concat(&1, nil))
  end

  defp reject_modules do
    [Helper]
    |> Enum.map(&Module.concat(NarouBot.Entity, &1))
    |> Enum.map(&to_string/1)
  end
end
