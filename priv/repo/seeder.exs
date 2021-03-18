import Ecto.Query
alias NarouBot.Repo
alias Repo.{
  Users,
  Novels,
  Writers,
  UsersCheckNovels,
  UsersCheckWriters,
  NovelEpisodes,
  NotificationFacts
}
alias NarouBot.Entity.{
  Novel,
  NovelEpisode
}

# ! USER
Users.new_user System.get_env("USERA")
Users.new_user System.get_env("USERB")

# ! NOVELS
ncodes = ~w(n0179fz n0358dh n0383gq n0423gu n0637gi n0776dq n0799fw n0806fu n1435ev n1720gr n1832fm n2267be n2330fy n2369gj n2494fq n2710db n2967go n3014fi n3289ds n3406ek n3976gk n3981fw n4185ci n4371s n4527bc n4750dy n5169el n5455cx n6041ev n6169dz n6362fe n6458eg n6486gs n6603go n6626ev n6811ck n6887gj n7200gt n7682fj n7728gs n7840gm n7850ds n7945fn n8329gj n8418ff n8760ei n9452fk n9984fb n7945fn n6362fe n6169dz n0089bk)

Enum.each(ncodes, &Novels.find_or_create_by/1)
Process.sleep(20000)

ucn_seed =[
  %{"id" => "1", "ncode" => "n2267be", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n7945fn", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n7945fn", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n8418ff", "reid" => "31", "type" => "read_later"},
  %{"id" => "1", "ncode" => "n6362fe", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n6362fe", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n6458eg", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n6169dz", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n6169dz", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n3981fw", "reid" => "180", "type" => "read_later"},
  %{"id" => "1", "ncode" => "n7850ds", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n6811ck", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n5455cx", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n3014fi", "reid" => "507", "type" => "read_later"},
  %{"id" => "1", "ncode" => "n0358dh", "reid" => "327", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n1720gr", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n2710db", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n1832fm", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n2330fy", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n6041ev", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n0179fz", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n3289ds", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n2494fq", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n4750dy", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n4527bc", "reid" => "279", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n0637gi", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n0776dq", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n5169el", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n3976gk", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n8329gj", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n2369gj", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n0799fw", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n7840gm", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n6887gj", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n4185ci", "reid" => "284", "type" => "read_later"},
  %{"id" => "1", "ncode" => "n8760ei", "reid" => "41", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n0383gq", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n1435ev", "reid" => "130", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n9984fb", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n6486gs", "reid" => "1", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n0423gu", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n3406ek", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n9452fk", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n2967go", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n0089bk", "reid" => "1", "type" => "read_later"},
  %{"id" => "1", "ncode" => "n7682fj", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n4371s", "reid" => "221", "type" => "read_later"},
  %{"id" => "1", "ncode" => "n6626ev", "reid" => "125", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n7200gt", "reid" => "", "type" => "update_notify"},
  %{"id" => "1", "ncode" => "n0806fu", "reid" => "1", "type" => "read_later"},
  %{"id" => "2", "ncode" => "n6603go", "reid" => "", "type" => "update_notify"},
  %{"id" => "2", "ncode" => "n7728gs", "reid" => "", "type" => "update_notify"}
]

Enum.each(ucn_seed, fn %{"id" => uid, "ncode" => ncode, "reid" => re_id} ->
  novel = Novels.find_by_ncode(ncode)
  case re_id do
    "" -> UsersCheckNovels.link_to(uid, novel.id)
    sid -> UsersCheckNovels.link_to(uid, novel.id, String.to_integer(sid))
  end
end)


# ! WRITER
link = &UsersCheckWriters.link_to(&1, Writers.find_by_remote_id(&2).id)

link.(1, 474038)
link.(1, 92438)
link.(2, 621868)

# ! NovelEpisodes
ne_seed = %{
  "n5169el" => [
    %{date: "2021-03-13 14:24:08Z", eid: 275, ncode: "n5169el"},
    %{date: "2021-02-27 13:18:06Z", eid: 274, ncode: "n5169el"},
    %{date: "2021-02-17 14:14:09Z", eid: 273, ncode: "n5169el"},
    %{date: "2021-02-01 02:25:21Z", eid: 272, ncode: "n5169el"},
    %{date: "2021-01-11 15:30:40Z", eid: 271, ncode: "n5169el"},
    %{date: "2021-01-01 15:39:51Z", eid: 270, ncode: "n5169el"},
    %{date: "2020-12-22 14:45:07Z", eid: 269, ncode: "n5169el"},
    %{date: "2020-12-14 15:10:48Z", eid: 268, ncode: "n5169el"},
    %{date: "2020-12-08 15:19:30Z", eid: 267, ncode: "n5169el"},
    %{date: "2020-12-06 15:06:25Z", eid: 266, ncode: "n5169el"}
  ],
  "n8418ff" => [%{date: "2020-06-11 11:28:56Z", eid: 42, ncode: "n8418ff"}],
  "n6486gs" => [
    %{date: "2021-03-07 13:00:00Z", eid: 40, ncode: "n6486gs"},
    %{date: "2021-03-07 09:00:00Z", eid: 39, ncode: "n6486gs"},
    %{date: "2021-03-06 13:00:00Z", eid: 38, ncode: "n6486gs"},
    %{date: "2021-03-05 13:00:00Z", eid: 37, ncode: "n6486gs"},
    %{date: "2021-03-04 13:00:00Z", eid: 36, ncode: "n6486gs"},
    %{date: "2021-03-03 13:00:00Z", eid: 35, ncode: "n6486gs"},
    %{date: "2021-03-02 13:00:00Z", eid: 34, ncode: "n6486gs"},
    %{date: "2021-03-01 13:00:00Z", eid: 33, ncode: "n6486gs"},
    %{date: "2021-02-28 12:00:00Z", eid: 32, ncode: "n6486gs"},
    %{date: "2021-02-27 12:00:00Z", eid: 31, ncode: "n6486gs"}
  ],
  "n0806fu" => [
    %{date: "2021-03-15 09:00:00Z", eid: 604, ncode: "n0806fu"},
    %{date: "2021-03-14 09:00:00Z", eid: 603, ncode: "n0806fu"},
    %{date: "2021-03-13 09:00:00Z", eid: 602, ncode: "n0806fu"},
    %{date: "2021-03-12 09:00:00Z", eid: 601, ncode: "n0806fu"},
    %{date: "2021-03-11 09:00:00Z", eid: 600, ncode: "n0806fu"},
    %{date: "2021-03-10 09:00:00Z", eid: 599, ncode: "n0806fu"},
    %{date: "2021-03-09 09:00:00Z", eid: 598, ncode: "n0806fu"},
    %{date: "2021-03-08 09:00:00Z", eid: 597, ncode: "n0806fu"},
    %{date: "2021-03-07 09:00:00Z", eid: 596, ncode: "n0806fu"},
    %{date: "2021-03-06 09:00:00Z", eid: 595, ncode: "n0806fu"}
  ],
  "n9984fb" => [%{date: "2021-02-01 02:00:00Z", eid: 257, ncode: "n9984fb"}],
  "n6458eg" => [
    %{date: "2020-12-31 18:29:09Z", eid: 69, ncode: "n6458eg"},
    %{date: "2020-11-09 02:46:47Z", eid: 68, ncode: "n6458eg"},
    %{date: "2020-08-31 22:52:13Z", eid: 67, ncode: "n6458eg"},
    %{date: "2020-08-29 02:00:35Z", eid: 66, ncode: "n6458eg"},
    %{date: "2020-08-28 08:13:28Z", eid: 65, ncode: "n6458eg"},
    %{date: "2020-08-27 12:50:10Z", eid: 64, ncode: "n6458eg"},
    %{date: "2020-08-07 09:16:32Z", eid: 63, ncode: "n6458eg"},
    %{date: "2020-06-13 14:59:53Z", eid: 62, ncode: "n6458eg"}
  ],
  "n6887gj" => [
    %{date: "2020-11-10 14:03:06Z", eid: 113, ncode: "n6887gj"},
    %{date: "2020-11-09 13:34:54Z", eid: 112, ncode: "n6887gj"},
    %{date: "2020-11-08 12:46:07Z", eid: 111, ncode: "n6887gj"},
    %{date: "2020-11-07 09:55:04Z", eid: 110, ncode: "n6887gj"},
    %{date: "2020-11-06 14:36:56Z", eid: 109, ncode: "n6887gj"},
    %{date: "2020-11-05 09:27:21Z", eid: 108, ncode: "n6887gj"},
    %{date: "2020-11-04 09:00:00Z", eid: 107, ncode: "n6887gj"},
    %{date: "2020-11-03 09:00:00Z", eid: 106, ncode: "n6887gj"},
    %{date: "2020-11-02 09:00:00Z", eid: 105, ncode: "n6887gj"},
    %{date: "2020-11-01 09:00:00Z", eid: 104, ncode: "n6887gj"}
  ],
  "n4185ci" => [
    %{date: "2021-03-13 15:00:00Z", eid: 659, ncode: "n4185ci"},
    %{date: "2021-03-06 15:00:00Z", eid: 658, ncode: "n4185ci"},
    %{date: "2021-02-27 15:00:00Z", eid: 657, ncode: "n4185ci"},
    %{date: "2021-02-20 15:00:00Z", eid: 656, ncode: "n4185ci"},
    %{date: "2021-02-13 15:00:00Z", eid: 655, ncode: "n4185ci"},
    %{date: "2021-02-06 15:00:00Z", eid: 654, ncode: "n4185ci"},
    %{date: "2021-01-30 15:00:00Z", eid: 653, ncode: "n4185ci"},
    %{date: "2021-01-23 15:00:00Z", eid: 652, ncode: "n4185ci"},
    %{date: "2021-01-16 15:00:00Z", eid: 651, ncode: "n4185ci"},
    %{date: "2021-01-09 15:00:00Z", eid: 650, ncode: "n4185ci"}
  ],
  "n2369gj" => [%{date: "2020-08-15 15:04:04Z", eid: 22, ncode: "n2369gj"}],
  "n6041ev" => [%{date: "2021-01-22 09:13:18Z", eid: 1, ncode: "n6041ev"}],
  "n6626ev" => [%{date: "2020-09-26 22:00:00Z", eid: 466, ncode: "n6626ev"}],
  "n2967go" => [
    %{date: "2021-03-10 03:00:00Z", eid: 200, ncode: "n2967go"},
    %{date: "2021-03-09 03:00:00Z", eid: 199, ncode: "n2967go"},
    %{date: "2021-03-02 03:00:00Z", eid: 198, ncode: "n2967go"},
    %{date: "2021-02-23 03:00:00Z", eid: 197, ncode: "n2967go"},
    %{date: "2021-02-16 03:00:00Z", eid: 196, ncode: "n2967go"},
    %{date: "2021-02-09 03:00:00Z", eid: 195, ncode: "n2967go"},
    %{date: "2021-02-02 03:00:00Z", eid: 194, ncode: "n2967go"},
    %{date: "2021-01-27 03:00:00Z", eid: 193, ncode: "n2967go"},
    %{date: "2021-01-23 03:00:00Z", eid: 192, ncode: "n2967go"},
    %{date: "2021-01-21 03:00:00Z", eid: 191, ncode: "n2967go"}
  ],
  "n7200gt" => [
    %{date: "2021-03-13 03:00:00Z", eid: 30, ncode: "n7200gt"},
    %{date: "2021-03-07 03:07:11Z", eid: 29, ncode: "n7200gt"},
    %{date: "2021-03-04 03:00:00Z", eid: 28, ncode: "n7200gt"},
    %{date: "2021-03-02 03:03:58Z", eid: 27, ncode: "n7200gt"},
    %{date: "2021-03-01 03:00:00Z", eid: 26, ncode: "n7200gt"},
    %{date: "2021-02-28 03:01:37Z", eid: 25, ncode: "n7200gt"},
    %{date: "2021-02-27 03:05:10Z", eid: 24, ncode: "n7200gt"},
    %{date: "2021-02-26 03:06:37Z", eid: 23, ncode: "n7200gt"},
    %{date: "2021-02-25 03:00:00Z", eid: 22, ncode: "n7200gt"},
    %{date: "2021-02-24 03:00:00Z", eid: 21, ncode: "n7200gt"}
  ],
  "n4527bc" => [%{date: "2019-04-19 09:00:00Z", eid: 359, ncode: "n4527bc"}],
  "n0089bk" => [
    %{date: "2021-03-12 11:00:00Z", eid: 507, ncode: "n0089bk"},
    %{date: "2021-03-05 11:00:00Z", eid: 506, ncode: "n0089bk"},
    %{date: "2021-02-26 11:00:00Z", eid: 505, ncode: "n0089bk"},
    %{date: "2021-02-12 11:37:33Z", eid: 504, ncode: "n0089bk"},
    %{date: "2021-01-29 11:00:00Z", eid: 503, ncode: "n0089bk"},
    %{date: "2021-01-22 11:00:00Z", eid: 502, ncode: "n0089bk"},
    %{date: "2021-01-15 11:00:00Z", eid: 501, ncode: "n0089bk"},
    %{date: "2021-01-08 11:00:00Z", eid: 500, ncode: "n0089bk"},
    %{date: "2021-01-01 11:00:00Z", eid: 499, ncode: "n0089bk"},
    %{date: "2020-12-25 11:00:00Z", eid: 498, ncode: "n0089bk"}
  ],
  "n9452fk" => [
    %{date: "2021-03-11 15:52:15Z", eid: 150, ncode: "n9452fk"},
    %{date: "2021-02-04 09:58:09Z", eid: 149, ncode: "n9452fk"},
    %{date: "2021-01-15 07:36:38Z", eid: 148, ncode: "n9452fk"},
    %{date: "2021-01-08 13:13:49Z", eid: 147, ncode: "n9452fk"},
    %{date: "2020-12-31 09:42:02Z", eid: 146, ncode: "n9452fk"},
    %{date: "2020-12-16 08:06:12Z", eid: 145, ncode: "n9452fk"},
    %{date: "2020-12-13 05:36:23Z", eid: 144, ncode: "n9452fk"},
    %{date: "2020-12-09 10:46:47Z", eid: 143, ncode: "n9452fk"},
    %{date: "2020-12-02 09:08:35Z", eid: 142, ncode: "n9452fk"},
    %{date: "2020-11-27 06:56:16Z", eid: 141, ncode: "n9452fk"}
  ],
  "n8329gj" => [
    %{date: "2021-02-28 03:03:09Z", eid: 77, ncode: "n8329gj"},
    %{date: "2021-02-27 01:11:34Z", eid: 76, ncode: "n8329gj"},
    %{date: "2021-02-26 08:06:33Z", eid: 75, ncode: "n8329gj"},
    %{date: "2021-02-25 14:00:00Z", eid: 74, ncode: "n8329gj"},
    %{date: "2021-02-23 23:00:00Z", eid: 73, ncode: "n8329gj"},
    %{date: "2021-02-23 01:00:00Z", eid: 72, ncode: "n8329gj"},
    %{date: "2021-02-22 06:12:17Z", eid: 71, ncode: "n8329gj"},
    %{date: "2021-02-21 02:07:43Z", eid: 70, ncode: "n8329gj"},
    %{date: "2021-02-20 06:34:00Z", eid: 69, ncode: "n8329gj"},
    %{date: "2021-02-19 00:11:30Z", eid: 68, ncode: "n8329gj"}
  ],
  "n1720gr" => [
    %{date: "2021-03-06 15:18:30Z", eid: 80, ncode: "n1720gr"},
    %{date: "2021-02-28 04:00:00Z", eid: 79, ncode: "n1720gr"},
    %{date: "2021-02-27 09:00:00Z", eid: 78, ncode: "n1720gr"},
    %{date: "2021-02-21 09:41:04Z", eid: 77, ncode: "n1720gr"},
    %{date: "2021-02-19 19:49:00Z", eid: 76, ncode: "n1720gr"},
    %{date: "2021-02-18 15:08:31Z", eid: 75, ncode: "n1720gr"},
    %{date: "2021-02-12 14:55:31Z", eid: 74, ncode: "n1720gr"},
    %{date: "2021-02-09 06:18:09Z", eid: 73, ncode: "n1720gr"},
    %{date: "2021-02-07 04:00:00Z", eid: 72, ncode: "n1720gr"},
    %{date: "2021-02-06 16:39:13Z", eid: 71, ncode: "n1720gr"}
  ],
  "n7945fn" => [
    %{date: "2021-02-04 09:00:00Z", eid: 215, ncode: "n7945fn"},
    %{date: "2021-02-03 10:00:00Z", eid: 214, ncode: "n7945fn"},
    %{date: "2021-01-11 09:00:00Z", eid: 213, ncode: "n7945fn"},
    %{date: "2021-01-09 09:00:00Z", eid: 212, ncode: "n7945fn"},
    %{date: "2021-01-05 09:00:00Z", eid: 211, ncode: "n7945fn"},
    %{date: "2020-12-17 09:00:00Z", eid: 210, ncode: "n7945fn"},
    %{date: "2020-12-07 09:00:00Z", eid: 209, ncode: "n7945fn"},
    %{date: "2020-11-18 09:00:00Z", eid: 208, ncode: "n7945fn"},
    %{date: "2020-11-16 10:00:00Z", eid: 207, ncode: "n7945fn"},
    %{date: "2020-09-06 09:00:00Z", eid: 206, ncode: "n7945fn"}
  ],
  "n0179fz" => [
    %{date: "2021-03-13 10:00:00Z", eid: 90, ncode: "n0179fz"},
    %{date: "2021-03-06 10:00:00Z", eid: 89, ncode: "n0179fz"},
    %{date: "2021-02-27 10:00:00Z", eid: 88, ncode: "n0179fz"},
    %{date: "2021-02-20 10:00:00Z", eid: 87, ncode: "n0179fz"},
    %{date: "2021-02-13 10:00:00Z", eid: 86, ncode: "n0179fz"},
    %{date: "2021-02-06 10:00:00Z", eid: 85, ncode: "n0179fz"},
    %{date: "2021-01-30 10:00:00Z", eid: 84, ncode: "n0179fz"},
    %{date: "2021-01-23 10:00:00Z", eid: 83, ncode: "n0179fz"},
    %{date: "2021-01-16 10:00:00Z", eid: 82, ncode: "n0179fz"},
    %{date: "2021-01-09 10:00:00Z", eid: 81, ncode: "n0179fz"}
  ],
  "n0383gq" => [%{date: "2020-12-29 12:01:31Z", eid: 41, ncode: "n0383gq"}],
  "n6603go" => [
    %{date: "2021-03-12 12:00:00Z", eid: 52, ncode: "n6603go"},
    %{date: "2021-03-05 12:00:00Z", eid: 51, ncode: "n6603go"},
    %{date: "2021-02-26 12:00:00Z", eid: 50, ncode: "n6603go"},
    %{date: "2021-02-19 12:00:00Z", eid: 49, ncode: "n6603go"},
    %{date: "2021-02-12 12:00:00Z", eid: 48, ncode: "n6603go"},
    %{date: "2021-02-05 12:00:00Z", eid: 47, ncode: "n6603go"},
    %{date: "2021-01-29 12:00:00Z", eid: 46, ncode: "n6603go"},
    %{date: "2021-01-27 12:00:00Z", eid: 45, ncode: "n6603go"},
    %{date: "2021-01-25 12:00:00Z", eid: 44, ncode: "n6603go"},
    %{date: "2021-01-22 12:00:00Z", eid: 43, ncode: "n6603go"}
  ],
  "n4371s" => [%{date: "2014-08-03 18:30:31Z", eid: 240, ncode: "n4371s"}],
  "n7728gs" => [
    %{date: "2021-03-15 02:09:13Z", eid: 52, ncode: "n7728gs"},
    %{date: "2021-03-14 02:06:01Z", eid: 51, ncode: "n7728gs"},
    %{date: "2021-03-13 02:00:00Z", eid: 50, ncode: "n7728gs"},
    %{date: "2021-03-11 02:00:00Z", eid: 49, ncode: "n7728gs"},
    %{date: "2021-03-09 02:20:52Z", eid: 48, ncode: "n7728gs"},
    %{date: "2021-03-07 03:06:03Z", eid: 47, ncode: "n7728gs"},
    %{date: "2021-03-05 02:10:31Z", eid: 46, ncode: "n7728gs"},
    %{date: "2021-03-03 02:22:10Z", eid: 45, ncode: "n7728gs"},
    %{date: "2021-03-01 02:00:00Z", eid: 44, ncode: "n7728gs"},
    %{date: "2021-02-28 02:03:41Z", eid: 43, ncode: "n7728gs"}
  ],
  "n0637gi" => [
    %{date: "2021-03-13 09:00:00Z", eid: 171, ncode: "n0637gi"},
    %{date: "2021-03-10 09:00:00Z", eid: 170, ncode: "n0637gi"},
    %{date: "2021-03-07 09:00:00Z", eid: 169, ncode: "n0637gi"},
    %{date: "2021-03-04 09:00:00Z", eid: 168, ncode: "n0637gi"},
    %{date: "2021-03-01 09:00:00Z", eid: 167, ncode: "n0637gi"},
    %{date: "2021-02-26 09:00:00Z", eid: 166, ncode: "n0637gi"},
    %{date: "2021-02-23 09:00:00Z", eid: 165, ncode: "n0637gi"},
    %{date: "2021-02-20 09:00:00Z", eid: 164, ncode: "n0637gi"},
    %{date: "2021-02-17 09:00:00Z", eid: 163, ncode: "n0637gi"},
    %{date: "2021-02-14 09:00:00Z", eid: 162, ncode: "n0637gi"}
  ],
  "n3406ek" => [
    %{date: "2021-03-14 11:00:00Z", eid: 649, ncode: "n3406ek"},
    %{date: "2021-03-12 11:00:00Z", eid: 648, ncode: "n3406ek"},
    %{date: "2021-03-10 11:00:00Z", eid: 647, ncode: "n3406ek"},
    %{date: "2021-03-08 11:00:00Z", eid: 646, ncode: "n3406ek"},
    %{date: "2021-03-06 11:00:00Z", eid: 645, ncode: "n3406ek"},
    %{date: "2021-03-04 11:00:00Z", eid: 644, ncode: "n3406ek"},
    %{date: "2021-03-02 11:00:00Z", eid: 643, ncode: "n3406ek"},
    %{date: "2021-02-28 11:00:00Z", eid: 642, ncode: "n3406ek"},
    %{date: "2021-02-26 11:00:00Z", eid: 641, ncode: "n3406ek"},
    %{date: "2021-02-24 11:00:00Z", eid: 640, ncode: "n3406ek"}
  ],
  "n0799fw" => [
    %{date: "2021-03-01 13:00:00Z", eid: 60, ncode: "n0799fw"},
    %{date: "2021-02-22 13:00:00Z", eid: 59, ncode: "n0799fw"},
    %{date: "2021-02-15 13:00:00Z", eid: 58, ncode: "n0799fw"},
    %{date: "2021-02-08 13:00:00Z", eid: 57, ncode: "n0799fw"},
    %{date: "2021-02-01 13:00:00Z", eid: 56, ncode: "n0799fw"},
    %{date: "2020-10-31 12:00:00Z", eid: 55, ncode: "n0799fw"},
    %{date: "2020-10-24 12:00:00Z", eid: 54, ncode: "n0799fw"},
    %{date: "2020-10-17 12:00:00Z", eid: 53, ncode: "n0799fw"},
    %{date: "2020-10-10 12:00:00Z", eid: 52, ncode: "n0799fw"},
    %{date: "2020-10-03 12:00:00Z", eid: 51, ncode: "n0799fw"}
  ],
  "n2267be" => [
    %{date: "2021-02-12 16:00:00Z", eid: 514, ncode: "n2267be"},
    %{date: "2021-02-10 16:00:00Z", eid: 513, ncode: "n2267be"},
    %{date: "2021-02-09 16:00:00Z", eid: 512, ncode: "n2267be"},
    %{date: "2021-02-08 16:00:00Z", eid: 511, ncode: "n2267be"},
    %{date: "2021-02-05 16:26:27Z", eid: 510, ncode: "n2267be"},
    %{date: "2021-02-02 16:00:00Z", eid: 509, ncode: "n2267be"},
    %{date: "2021-01-30 16:00:00Z", eid: 508, ncode: "n2267be"},
    %{date: "2021-01-28 16:00:00Z", eid: 507, ncode: "n2267be"},
    %{date: "2021-01-26 16:00:00Z", eid: 506, ncode: "n2267be"},
    %{date: "2021-01-25 16:00:00Z", eid: 505, ncode: "n2267be"}
  ],
  "n6362fe" => [
    %{date: "2021-02-06 11:00:00Z", eid: 128, ncode: "n6362fe"},
    %{date: "2021-02-02 11:00:00Z", eid: 127, ncode: "n6362fe"},
    %{date: "2021-01-21 11:00:00Z", eid: 126, ncode: "n6362fe"},
    %{date: "2021-01-17 11:00:00Z", eid: 125, ncode: "n6362fe"},
    %{date: "2021-01-14 11:00:00Z", eid: 124, ncode: "n6362fe"},
    %{date: "2021-01-10 11:00:00Z", eid: 123, ncode: "n6362fe"},
    %{date: "2021-01-07 11:00:00Z", eid: 122, ncode: "n6362fe"},
    %{date: "2021-01-04 04:47:56Z", eid: 121, ncode: "n6362fe"},
    %{date: "2020-12-31 23:00:00Z", eid: 120, ncode: "n6362fe"},
    %{date: "2020-12-02 11:00:00Z", eid: 119, ncode: "n6362fe"}
  ],
  "n3289ds" => [
    %{date: "2021-02-19 07:57:16Z", eid: 688, ncode: "n3289ds"},
    %{date: "2021-02-10 20:59:51Z", eid: 687, ncode: "n3289ds"},
    %{date: "2021-02-04 16:11:19Z", eid: 686, ncode: "n3289ds"},
    %{date: "2021-02-02 14:22:23Z", eid: 685, ncode: "n3289ds"},
    %{date: "2021-02-01 16:25:08Z", eid: 684, ncode: "n3289ds"},
    %{date: "2021-01-31 17:04:56Z", eid: 683, ncode: "n3289ds"},
    %{date: "2021-01-30 13:59:17Z", eid: 682, ncode: "n3289ds"},
    %{date: "2021-01-29 14:40:16Z", eid: 681, ncode: "n3289ds"},
    %{date: "2021-01-28 14:32:14Z", eid: 680, ncode: "n3289ds"},
    %{date: "2021-01-27 14:52:17Z", eid: 679, ncode: "n3289ds"}
  ],
  "n4750dy" => [
    %{date: "2021-02-28 12:20:52Z", eid: 25, ncode: "n4750dy"},
    %{date: "2021-02-27 09:07:56Z", eid: 24, ncode: "n4750dy"},
    %{date: "2020-11-08 02:13:36Z", eid: 23, ncode: "n4750dy"},
    %{date: "2020-10-13 02:26:49Z", eid: 22, ncode: "n4750dy"},
    %{date: "2020-05-04 02:57:56Z", eid: 21, ncode: "n4750dy"}
  ],
  "n1832fm" => [
    %{date: "2021-02-27 21:15:40Z", eid: 104, ncode: "n1832fm"},
    %{date: "2021-02-26 09:00:00Z", eid: 103, ncode: "n1832fm"},
    %{date: "2021-02-18 14:40:25Z", eid: 102, ncode: "n1832fm"},
    %{date: "2021-02-15 09:00:00Z", eid: 101, ncode: "n1832fm"},
    %{date: "2021-02-11 02:00:00Z", eid: 100, ncode: "n1832fm"},
    %{date: "2021-01-31 09:41:46Z", eid: 99, ncode: "n1832fm"},
    %{date: "2021-01-30 08:11:06Z", eid: 98, ncode: "n1832fm"},
    %{date: "2020-11-30 07:16:29Z", eid: 97, ncode: "n1832fm"},
    %{date: "2020-11-10 01:57:18Z", eid: 96, ncode: "n1832fm"},
    %{date: "2020-11-02 10:38:35Z", eid: 95, ncode: "n1832fm"}
  ],
  "n3976gk" => [
    %{date: "2021-03-14 12:00:00Z", eid: 184, ncode: "n3976gk"},
    %{date: "2021-03-12 15:00:00Z", eid: 183, ncode: "n3976gk"},
    %{date: "2021-03-10 11:40:05Z", eid: 182, ncode: "n3976gk"},
    %{date: "2021-03-06 10:00:00Z", eid: 181, ncode: "n3976gk"},
    %{date: "2021-03-03 10:00:00Z", eid: 180, ncode: "n3976gk"},
    %{date: "2021-02-28 15:00:00Z", eid: 179, ncode: "n3976gk"},
    %{date: "2021-02-23 15:00:00Z", eid: 178, ncode: "n3976gk"},
    %{date: "2021-02-19 10:00:00Z", eid: 177, ncode: "n3976gk"},
    %{date: "2021-02-16 10:00:00Z", eid: 176, ncode: "n3976gk"},
    %{date: "2021-02-13 10:00:00Z", eid: 175, ncode: "n3976gk"}
  ],
  "n0776dq" => [
    %{date: "2021-03-12 02:25:32Z", eid: 605, ncode: "n0776dq"},
    %{date: "2021-03-08 14:21:49Z", eid: 604, ncode: "n0776dq"},
    %{date: "2021-03-07 06:55:11Z", eid: 603, ncode: "n0776dq"},
    %{date: "2021-03-04 10:52:07Z", eid: 602, ncode: "n0776dq"},
    %{date: "2021-02-28 14:15:57Z", eid: 601, ncode: "n0776dq"},
    %{date: "2021-02-28 07:16:52Z", eid: 600, ncode: "n0776dq"},
    %{date: "2021-02-27 10:58:20Z", eid: 599, ncode: "n0776dq"},
    %{date: "2021-02-25 10:46:10Z", eid: 598, ncode: "n0776dq"},
    %{date: "2021-02-20 14:58:19Z", eid: 597, ncode: "n0776dq"},
    %{date: "2021-02-19 13:46:18Z", eid: 596, ncode: "n0776dq"}
  ],
  "n0358dh" => [
    %{date: "2021-01-06 03:53:41Z", eid: 364, ncode: "n0358dh"},
    %{date: "2021-01-05 16:22:09Z", eid: 363, ncode: "n0358dh"},
    %{date: "2021-01-05 11:51:48Z", eid: 362, ncode: "n0358dh"},
    %{date: "2021-01-05 03:25:43Z", eid: 361, ncode: "n0358dh"},
    %{date: "2021-01-04 03:48:41Z", eid: 360, ncode: "n0358dh"},
    %{date: "2021-01-03 06:23:53Z", eid: 359, ncode: "n0358dh"},
    %{date: "2021-01-03 03:26:54Z", eid: 358, ncode: "n0358dh"},
    %{date: "2021-01-02 16:13:47Z", eid: 357, ncode: "n0358dh"},
    %{date: "2021-01-02 12:32:06Z", eid: 356, ncode: "n0358dh"},
    %{date: "2021-01-02 09:07:19Z", eid: 355, ncode: "n0358dh"}
  ],
  "n2330fy" => [
    %{date: "2021-02-25 17:25:57Z", eid: 55, ncode: "n2330fy"},
    %{date: "2020-10-29 13:27:30Z", eid: 54, ncode: "n2330fy"},
    %{date: "2020-09-02 11:00:00Z", eid: 53, ncode: "n2330fy"},
    %{date: "2020-05-18 13:00:00Z", eid: 52, ncode: "n2330fy"}
  ],
  "n2710db" => [
    %{date: "2021-03-15 13:53:53Z", eid: 559, ncode: "n2710db"},
    %{date: "2021-03-01 15:12:04Z", eid: 558, ncode: "n2710db"},
    %{date: "2021-02-22 16:16:13Z", eid: 557, ncode: "n2710db"},
    %{date: "2021-02-15 13:19:35Z", eid: 556, ncode: "n2710db"},
    %{date: "2021-02-08 13:31:19Z", eid: 555, ncode: "n2710db"},
    %{date: "2021-02-01 13:19:18Z", eid: 554, ncode: "n2710db"},
    %{date: "2021-01-25 14:20:19Z", eid: 553, ncode: "n2710db"},
    %{date: "2021-01-18 13:13:17Z", eid: 552, ncode: "n2710db"},
    %{date: "2021-01-11 12:21:35Z", eid: 551, ncode: "n2710db"},
    %{date: "2021-01-04 13:48:34Z", eid: 550, ncode: "n2710db"}
  ],
  "n6811ck" => [
    %{date: "2021-02-14 13:26:04Z", eid: 148, ncode: "n6811ck"},
    %{date: "2021-02-14 13:26:04Z", eid: 148, ncode: "n6811ck"},
    %{date: "2021-02-14 13:26:04Z", eid: 148, ncode: "n6811ck"},
    %{date: "2021-02-05 10:59:32Z", eid: 147, ncode: "n6811ck"},
    %{date: "2020-05-03 14:02:44Z", eid: 146, ncode: "n6811ck"}
  ],
  "n0423gu" => [
    %{date: "2021-03-13 22:00:00Z", eid: 39, ncode: "n0423gu"},
    %{date: "2021-03-06 22:00:00Z", eid: 38, ncode: "n0423gu"},
    %{date: "2021-03-01 23:00:00Z", eid: 37, ncode: "n0423gu"},
    %{date: "2021-02-26 22:00:00Z", eid: 36, ncode: "n0423gu"},
    %{date: "2021-02-25 22:00:00Z", eid: 35, ncode: "n0423gu"},
    %{date: "2021-02-24 22:00:00Z", eid: 34, ncode: "n0423gu"},
    %{date: "2021-02-24 09:30:26Z", eid: 33, ncode: "n0423gu"},
    %{date: "2021-02-22 18:15:03Z", eid: 32, ncode: "n0423gu"},
    %{date: "2021-02-21 13:41:54Z", eid: 31, ncode: "n0423gu"},
    %{date: "2021-02-20 05:00:48Z", eid: 30, ncode: "n0423gu"}
  ],
  "n7840gm" => [
    %{date: "2021-03-14 06:00:00Z", eid: 167, ncode: "n7840gm"},
    %{date: "2021-03-12 14:00:00Z", eid: 166, ncode: "n7840gm"},
    %{date: "2021-03-10 11:16:30Z", eid: 165, ncode: "n7840gm"},
    %{date: "2021-03-08 08:41:04Z", eid: 164, ncode: "n7840gm"},
    %{date: "2021-03-06 07:33:32Z", eid: 163, ncode: "n7840gm"},
    %{date: "2021-03-04 09:18:11Z", eid: 162, ncode: "n7840gm"},
    %{date: "2021-03-02 09:34:13Z", eid: 161, ncode: "n7840gm"},
    %{date: "2021-02-28 07:30:43Z", eid: 160, ncode: "n7840gm"},
    %{date: "2021-02-26 10:43:05Z", eid: 159, ncode: "n7840gm"},
    %{date: "2021-02-24 08:24:02Z", eid: 158, ncode: "n7840gm"}
  ],
  "n8760ei" => [
    %{date: "2021-01-28 11:00:00Z", eid: 71, ncode: "n8760ei"},
    %{date: "2021-01-24 11:00:00Z", eid: 70, ncode: "n8760ei"},
    %{date: "2021-01-21 11:00:00Z", eid: 69, ncode: "n8760ei"},
    %{date: "2021-01-17 11:00:00Z", eid: 68, ncode: "n8760ei"},
    %{date: "2021-01-12 11:00:00Z", eid: 67, ncode: "n8760ei"},
    %{date: "2020-12-08 11:00:00Z", eid: 66, ncode: "n8760ei"}
  ],
  "n3014fi" => [
    %{date: "2021-03-15 03:00:00Z", eid: 854, ncode: "n3014fi"},
    %{date: "2021-03-15 03:00:00Z", eid: 854, ncode: "n3014fi"},
    %{date: "2021-03-14 03:00:00Z", eid: 853, ncode: "n3014fi"},
    %{date: "2021-03-13 03:00:00Z", eid: 852, ncode: "n3014fi"},
    %{date: "2021-03-12 03:00:00Z", eid: 851, ncode: "n3014fi"},
    %{date: "2021-03-11 03:00:00Z", eid: 850, ncode: "n3014fi"},
    %{date: "2021-03-10 03:00:00Z", eid: 849, ncode: "n3014fi"},
    %{date: "2021-03-09 03:00:00Z", eid: 848, ncode: "n3014fi"},
    %{date: "2021-03-08 03:00:00Z", eid: 847, ncode: "n3014fi"},
    %{date: "2021-03-07 03:00:00Z", eid: 846, ncode: "n3014fi"}
  ],
  "n7682fj" => [
    %{date: "2021-02-20 10:43:30Z", eid: 114, ncode: "n7682fj"},
    %{date: "2021-02-04 14:00:00Z", eid: 113, ncode: "n7682fj"},
    %{date: "2021-01-18 17:57:22Z", eid: 112, ncode: "n7682fj"},
    %{date: "2020-12-07 18:00:00Z", eid: 111, ncode: "n7682fj"},
    %{date: "2020-11-01 18:05:43Z", eid: 110, ncode: "n7682fj"},
    %{date: "2020-10-01 17:20:33Z", eid: 109, ncode: "n7682fj"}
  ],
  "n1435ev" => [
    %{date: "2020-10-13 07:03:33Z", eid: 133, ncode: "n1435ev"},
    %{date: "2020-10-13 06:59:24Z", eid: 132, ncode: "n1435ev"},
    %{date: "2020-10-10 10:09:52Z", eid: 131, ncode: "n1435ev"},
    %{date: "2020-10-06 11:26:25Z", eid: 130, ncode: "n1435ev"},
    %{date: "2020-10-02 09:47:53Z", eid: 129, ncode: "n1435ev"},
    %{date: "2020-09-25 14:49:27Z", eid: 128, ncode: "n1435ev"},
    %{date: "2020-09-17 15:07:21Z", eid: 127, ncode: "n1435ev"},
    %{date: "2020-09-09 14:27:36Z", eid: 126, ncode: "n1435ev"},
    %{date: "2020-09-02 11:00:31Z", eid: 125, ncode: "n1435ev"},
    %{date: "2020-08-26 14:59:19Z", eid: 124, ncode: "n1435ev"}
  ],
  "n3981fw" => [
    %{date: "2021-03-03 09:00:00Z", eid: 270, ncode: "n3981fw"},
    %{date: "2021-02-09 09:16:07Z", eid: 269, ncode: "n3981fw"},
    %{date: "2021-01-21 12:32:06Z", eid: 268, ncode: "n3981fw"},
    %{date: "2021-01-08 10:05:22Z", eid: 267, ncode: "n3981fw"},
    %{date: "2020-12-31 14:41:05Z", eid: 266, ncode: "n3981fw"},
    %{date: "2020-12-30 09:16:44Z", eid: 265, ncode: "n3981fw"},
    %{date: "2020-12-24 15:10:47Z", eid: 264, ncode: "n3981fw"},
    %{date: "2020-12-23 09:15:41Z", eid: 263, ncode: "n3981fw"},
    %{date: "2020-12-18 14:23:18Z", eid: 262, ncode: "n3981fw"},
    %{date: "2020-12-11 03:10:33Z", eid: 261, ncode: "n3981fw"}
  ],
  "n2494fq" => [
    %{date: "2021-03-10 23:09:21Z", eid: 212, ncode: "n2494fq"},
    %{date: "2021-03-05 12:55:07Z", eid: 211, ncode: "n2494fq"},
    %{date: "2021-02-28 10:48:51Z", eid: 210, ncode: "n2494fq"},
    %{date: "2021-02-23 13:17:18Z", eid: 209, ncode: "n2494fq"},
    %{date: "2021-02-18 09:05:41Z", eid: 208, ncode: "n2494fq"},
    %{date: "2021-02-15 07:23:23Z", eid: 207, ncode: "n2494fq"},
    %{date: "2021-02-10 09:51:59Z", eid: 206, ncode: "n2494fq"},
    %{date: "2021-02-06 11:29:01Z", eid: 205, ncode: "n2494fq"},
    %{date: "2021-02-02 13:43:40Z", eid: 204, ncode: "n2494fq"},
    %{date: "2021-01-29 00:54:53Z", eid: 203, ncode: "n2494fq"}
  ],
  "n6169dz" => [
    %{date: "2021-03-15 13:18:31Z", eid: 789, ncode: "n6169dz"},
    %{date: "2021-03-09 07:46:39Z", eid: 788, ncode: "n6169dz"},
    %{date: "2021-03-06 18:48:51Z", eid: 787, ncode: "n6169dz"},
    %{date: "2021-02-28 10:43:34Z", eid: 786, ncode: "n6169dz"},
    %{date: "2021-02-27 08:31:52Z", eid: 785, ncode: "n6169dz"},
    %{date: "2021-02-22 22:29:01Z", eid: 784, ncode: "n6169dz"},
    %{date: "2021-02-16 18:56:40Z", eid: 783, ncode: "n6169dz"},
    %{date: "2021-02-15 14:40:35Z", eid: 782, ncode: "n6169dz"},
    %{date: "2021-02-14 12:09:41Z", eid: 781, ncode: "n6169dz"},
    %{date: "2021-02-11 15:30:44Z", eid: 780, ncode: "n6169dz"}
  ],
  "n5455cx" => [
    %{date: "2020-12-31 13:00:00Z", eid: 534, ncode: "n5455cx"},
    %{date: "2020-12-31 12:00:00Z", eid: 533, ncode: "n5455cx"},
    %{date: "2020-12-30 12:00:00Z", eid: 532, ncode: "n5455cx"},
    %{date: "2020-12-29 12:00:00Z", eid: 531, ncode: "n5455cx"},
    %{date: "2020-12-28 12:00:00Z", eid: 530, ncode: "n5455cx"},
    %{date: "2020-12-24 12:00:00Z", eid: 529, ncode: "n5455cx"},
    %{date: "2020-12-20 12:00:00Z", eid: 528, ncode: "n5455cx"},
    %{date: "2020-12-16 13:00:00Z", eid: 527, ncode: "n5455cx"},
    %{date: "2020-12-16 12:00:00Z", eid: 526, ncode: "n5455cx"},
    %{date: "2020-12-12 12:00:00Z", eid: 525, ncode: "n5455cx"}
  ],
  "n7850ds" => [%{date: "2020-05-24 09:02:05Z", eid: 151, ncode: "n7850ds"}]
}

Enum.each(ne_seed, fn {ncode, episodes} ->
  novel = Novels.find_by_ncode(ncode)

  Enum.each(episodes, fn %{date: date, eid: eid} ->
    date = DateTime.from_iso8601(date) |> elem(1) |> DateTime.add(3600 * 9) |> inspect |> String.slice(3..-3)
    NovelEpisodes.create(%{novel_id: novel.id, episode_id: eid, remote_created_at: date})
  end)
end)
