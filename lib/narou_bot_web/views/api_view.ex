defmodule NarouBotWeb.Views.ApiView do
    use NarouBotWeb, :view
    require Logger

    alias NarouBot.Repo
    alias __MODULE__.Extracted, as: Ex

    # writers: [{user_id, [writer_id, ...]}]
    # novels: [%NarouBot.Entity.Novel{}, ...]
    # target_user_ids: [1, 2, ...]
    # extracted: %Extracted{}
    defstruct [:extracted, :novels, :writers, :target_user_ids]

    defmodule Extracted do
      defstruct [:fetch_writer_ids, :novel_episodes, :user_register_novels, :user_register_writers]
    end

    def render("dump.json", _) do
      new(%Ex{})
      |> dump_records()
      |> do_render()
    end

    def ent do
      new(%Ex{})
      |> dump_records()
    end

    defp new(extracted) do
      %__MODULE__{extracted: extracted}
    end

    # %{
    #   fetch_writer_ids: List(Integer()),
    #   novel_episodes: List(Map(ncode: List(Map(episode_id: unix_time)))),
    #   user_register_novels:  List(Map(user_id:, ncode:, do_notify:, restart_episode_id:, turn_off_notification_at:, type:)),
    #   user_register_writers: List(Map(user_id:, writer_id:))
    # }

    defp dump_records(self) do
      # user_register_novels
      # user_register_writers
      # novel_episodes

      dump_terget_user_ids(self)
      # ユーザ登録データ抽出
      |> extraction_of_registered_data()
      # ダンプ対象の作者ID一覧を書き出し
      |> extraction_of_writer_id_for_fetch()
      # ユーザ登録されている小説のエピソード一覧12話分を書き出し
      |> extraction_of_user_regster_novel_episodes()
      # ユーザ登録のNcode, WriterID一覧を書き出し
      |> extraction_of_user_register_novels()
      |> extraction_of_user_register_writers()
    end

    defp dump_terget_user_ids(self) do
      ids =
        Repo.all(NarouBot.Entity.User)
        |> Enum.map(&Map.get(&1, :id))

      %__MODULE__{self | target_user_ids: ids}
    end

    defp extraction_of_registered_data(%__MODULE__{target_user_ids: ids} = self) do
      novels =
        Enum.map(ids, fn id ->
          Enum.map(["update_notify", "read_later"], &Repo.Novels.novel_detail(:all, &1, id))
        end)
        |> Enum.flat_map(&Enum.flat_map(&1, fn t -> t end))

      writers =
        Enum.map(ids, fn id ->
          Repo.Writers.writer_detail(id)
          |> Enum.map(&(&1.remote_id))
          |> then(&({id, &1}))
        end)

      %__MODULE__{self | novels: novels, writers: writers}
    end

    defp extraction_of_writer_id_for_fetch(%__MODULE__{novels: novels, writers: writers, extracted: extracted} = self) do
      writer_ids =
        Enum.map(novels, &(&1.writer.remote_id))
        |> Kernel.++(
          Enum.map(writers, &elem(&1, 1))
          |> Enum.flat_map(&(&1))
        )
        |> Enum.uniq

      %__MODULE__{self | extracted: %Ex{extracted | fetch_writer_ids: writer_ids}}
    end

    defp extraction_of_user_regster_novel_episodes(%__MODULE__{novels: novels, extracted: extracted} = self) do
      novel_episodes =
        Enum.map(novels, &({&1.id, &1.ncode}))
        |> Enum.uniq_by(&elem(&1, 1))
        |> Enum.map(fn {id, ncode} ->
          episodes =
            Repo.NovelEpisodes.leatest_update_history(id, 12)
            |> Enum.map(fn %{created_at: created_at} = episode_info ->
              %{episode_info | created_at: to_unix_time(created_at)}
            end)

          %{ncode: ncode, episodes: episodes}
        end)

      %__MODULE__{self | extracted: %Ex{extracted | novel_episodes: novel_episodes}}
    end

    defp extraction_of_user_register_novels(%__MODULE__{novels: novels, target_user_ids: ids, extracted: extracted} = self) do
      user_register_novels =
        # ユーザID毎の要素
        Enum.map(ids, fn u_id ->
          Enum.filter(novels, &Kernel.==(&1.check_user.user_id, u_id))
          |> Enum.map(fn novel ->
            c = novel.check_user

            %{
              ncode: novel.ncode,
              do_notify: c.do_notify,
              restart_episode_id: c.restart_episode_id,
              turn_off_notification_at: to_unix_time(c.turn_off_notification_at),
              type: c.type
            }
          end)
          |> then(&(%{u_id => &1}))
        end)

      %__MODULE__{self | extracted: %Ex{extracted | user_register_novels: user_register_novels}}
    end

    defp extraction_of_user_register_writers(%__MODULE__{writers: writers, extracted: extracted} = self) do
      %__MODULE__{self | extracted: %Ex{extracted | user_register_writers: Map.new(writers)}}
    end


    defp to_unix_time(nil), do: nil
    defp to_unix_time(%DateTime{} = datetime), do: DateTime.to_unix(datetime)

    defp do_render(%__MODULE__{extracted: extracted}) do
      Map.drop(extracted, [:__struct__])
    end
end
