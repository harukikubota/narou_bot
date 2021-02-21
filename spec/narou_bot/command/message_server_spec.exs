defmodule NarouBot.Command.MessageServerSpec do
  use ESpec

  alias NarouBot.Command.MessageServer, as: MS

  describe "#start_link/2" do
    it do: expect MS.start_link(self(), "token") |> to(be_ok_result())
  end

  describe "#get_reply_token/1" do
    context "ok" do
      let! :m, do: MS.start_link(self(), "token")
      it do: expect MS.get_reply_token(self()) |> to(eq "token")
    end

    context "put up two" do
      let! :m1_pid, do: spawn(fn -> 0 end)
      let! :m2_pid, do: spawn(fn -> 0 end)
      let! :m1, do: MS.start_link(m1_pid(), "token1")
      let! :m2, do: MS.start_link(m2_pid(), "token2")

      it do: expect MS.get_reply_token(m1_pid()) |> to(eq "token1")
      it do: expect MS.get_reply_token(m2_pid()) |> to(eq "token2")
    end
  end

  describe "#get_messages/1" do
    context "default" do
      let! :m, do: MS.start_link(self(), "token")
      it do: expect MS.get_messages(self()) |> to(eq [])
    end

    context "message pushed" do
      let! :m, do: MS.start_link(self(), "token")
      let! :push, do: MS.push_message(self(), "hogehoge")

      it do: expect MS.get_messages(self()) |> to(eq ["hogehoge"])
    end

    context "push any messages" do
      let! :m, do: MS.start_link(self(), "token")
      let! :push1, do: MS.push_message(self(), "hogehoge1")
      let! :push2, do: MS.push_message(self(), "hogehoge2")

      it do: expect MS.get_messages(self()) |> to(eq ["hogehoge1", "hogehoge2"])
    end
  end

  describe "#get_dao/1" do
    context "default" do
      let! :m, do: MS.start_link(self(), "token")
      it do: expect MS.get_dao(self()) |> to(eq %{})
    end

    context "val pushed" do
      let! :m, do: MS.start_link(self(), "token")
      let! :push, do: MS.push_val(self(), :hoge, 1)

      it do: expect MS.get_dao(self()) |> to(eq %{hoge: 1})
    end
  end

  describe "#stop/1" do
    let! :m, do: MS.start_link(self(), "token")

    it do: expect MS.stop(self()) |> to(eq :ok)
  end

end
