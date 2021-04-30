defmodule WebHnWeb.StoryControllerTest do
  use WebHnWeb.ConnCase

  alias WebHn.Posts

  @create_attrs %{by: "some by", descendants: 42, id: 42, score: 42, time: "2010-04-17T14:00:00Z", title: "some title", url: "some url"}
  @update_attrs %{by: "some updated by", descendants: 43, id: 43, score: 43, time: "2011-05-18T15:01:01Z", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{by: nil, descendants: nil, id: nil, score: nil, time: nil, title: nil, url: nil}

  def fixture(:story) do
    {:ok, story} = Posts.create_story(@create_attrs)
    story
  end

  describe "index" do
    test "lists all stories", %{conn: conn} do
      conn = get(conn, Routes.story_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Stories"
    end
  end

  describe "new story" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.story_path(conn, :new))
      assert html_response(conn, 200) =~ "New Story"
    end
  end

  describe "create story" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.story_path(conn, :create), story: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.story_path(conn, :show, id)

      conn = get(conn, Routes.story_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Story"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.story_path(conn, :create), story: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Story"
    end
  end

  describe "edit story" do
    setup [:create_story]

    test "renders form for editing chosen story", %{conn: conn, story: story} do
      conn = get(conn, Routes.story_path(conn, :edit, story))
      assert html_response(conn, 200) =~ "Edit Story"
    end
  end

  describe "update story" do
    setup [:create_story]

    test "redirects when data is valid", %{conn: conn, story: story} do
      conn = put(conn, Routes.story_path(conn, :update, story), story: @update_attrs)
      assert redirected_to(conn) == Routes.story_path(conn, :show, story)

      conn = get(conn, Routes.story_path(conn, :show, story))
      assert html_response(conn, 200) =~ "some updated by"
    end

    test "renders errors when data is invalid", %{conn: conn, story: story} do
      conn = put(conn, Routes.story_path(conn, :update, story), story: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Story"
    end
  end

  describe "delete story" do
    setup [:create_story]

    test "deletes chosen story", %{conn: conn, story: story} do
      conn = delete(conn, Routes.story_path(conn, :delete, story))
      assert redirected_to(conn) == Routes.story_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.story_path(conn, :show, story))
      end
    end
  end

  defp create_story(_) do
    story = fixture(:story)
    %{story: story}
  end
end
