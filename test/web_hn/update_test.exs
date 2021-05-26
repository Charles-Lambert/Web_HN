defmodule WebHn.UpdateTest do
  use WebHn.DataCase
  alias WebHn.Update
  import Mox

  setup :verify_on_exit!

  setup_all do
    story_json = %HTTPoison.Response{
      body: ~s({"by":"Alice","descendants":0,"id":1001,"score":1,"time":1621862301,"title":"Let's Talk about Luddites","type":"story","url":"example.com"})}
    story_struct = %{
     "by" => "Alice",
     "descendants" => 0,
     "id" => 1001,
     "score" => 1,
     "time" => ~U[2021-05-24 13:18:21Z],
     "title" => "Let's Talk about Luddites",
     "type" => "story",
     "url" => "example.com"
    }
    {:ok, [story_json: story_json, story_struct: story_struct]}
  end

  test "gets list and decodes json" do
    expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, %HTTPoison.Response{body: "[1001,1002,1003,2004]"}} end)

    assert {:ok, [1001, 1002, 1003, 2004]} = Update.get_id_list("url")
  end

  test "gets story details", state do

    expect(HTTPoison.BaseMock, :get, fn _ ->{:ok, state[:story_json]} end)

    story_struct = state[:story_struct]
    assert {:ok, story_struct} = Update.get_details(1001, "url", %{}) |> IO.inspect

  end

  test "gets details list", state do

    expect(HTTPoison.BaseMock, :get, fn _ -> {:ok, %HTTPoison.Response{body: "[1001,1002,1003,2004]"}} end)
    |> expect(:get, 3, fn _ ->{:ok, state[:story_json]} end)

    story_struct = state[:story_struct]
    assert [story_struct, story_struct, story_struct] = WebHn.Update.details_list("url", "url", %{}, 3) |> IO.inspect
  end

end
