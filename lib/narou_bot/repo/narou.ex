defmodule NarouBot.Repo.Narou do
  import Narou.Query
  import Narou.Util

  @doc """
  小説を一件検索する。
  デフォルト引数：小説のエピソード数、ユーザID、タイトルを取得する。
  """
  def find_by_ncode(ncode, cols \\ [:general_all_no, :userid, :title])
    when is_binary(ncode) do
    unless is_ncode(ncode), do: raise ArgumentError, "require `ncode` : #{ncode}."

    case from(:novel, select: cols, where: [ncode: ncode]) |> _exec! do
      {:ok, 1, [result]} -> {:ok, result}
      {:no_data}         -> {:no_data}
    end
  end

  @doc """
  小説の複数件検索する。
  デフォルト引数：小説のエピソード数を取得する。
  """
  @spec find_by_ncodes(list(atom), list(atom)) :: {:ok, integer(), [map()]} | {:nodata}
  def find_by_ncodes(ncodes, cols \\ [:ncode, :general_all_no])
    when is_list(ncodes) do
    unless Enum.all?(ncodes, &is_ncode/1), do: raise ArgumentError, "require `ncode` : #{inspect(ncodes)}."

    from(:novel, select: cols, where: [ncode: ncodes], order: :ncodedesc)
    |> _exec!
  end

  @doc """
  デフォルト引数：ユーザIDを条件に小説を複数件検索する。
  """
  @spec find_by_userid(integer(), list(atom)) :: term
  def find_by_userid(userid, cols \\ [:n, :t, :ga, :gl, :nt, :e]) do
    from(:novel, maximum_fetch_mode: true, select: List.wrap(cols), where: [userid: userid], order: :ncodedesc)
    |> _exec!
  end

  def find_by_userid_for_writer_detail(userid, cols \\ [:name]) do
    case from(:user, select: List.wrap(cols), where: [userid: userid]) |> _exec! do
      {:ok, _, [result]} -> result
      {:no_data}         -> {:no_data}
    end
  end

  def novel_detail(ncode, cols \\ [:length, :global_point]) do
    {:ok, 1, [result]} = _exec!(from(:novel, select: cols, where: [ncode: ncode]))
    result
  end

  defp _exec!(map), do: Narou.run!(map) |> Narou.format
end
