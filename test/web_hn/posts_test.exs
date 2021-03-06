defmodule WebHn.PostsTest do
  use WebHn.DataCase

  alias WebHn.Posts

  describe "stories" do
    alias WebHn.Posts.Story

    @valid_attrs %{by: "some by", descendants: 42, id: 42, score: 42, time: "2010-04-17T14:00:00Z", title: "some title", url: "some url"}
    @ask_hn_attrs %{by: "some by", descendants: 42, id: 42, score: 42, time: "2010-04-17T14:00:00Z", title: "some title", url: nil}
    @update_attrs %{by: "some updated by", descendants: 43, id: 43, score: 43, time: "2011-05-18T15:01:01Z", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{by: nil, descendants: nil, id: nil, score: nil, time: nil, title: nil, url: nil}

    def story_fixture(attrs \\ %{}) do
      {:ok, story} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_story()

      story
    end

    test "list_stories/0 returns all stories" do
      story = story_fixture()
      assert Posts.list_stories() == [story]
    end

    test "get_story!/1 returns the story with given id" do
      story = story_fixture()
      assert Posts.get_story!(story.id) == story
    end

    test "create_story/1 with valid data creates a story" do
      assert {:ok, %Story{} = story} = Posts.create_story(@valid_attrs)
      assert story.by == "some by"
      assert story.descendants == 42
      assert story.id == 42
      assert story.score == 42
      assert story.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert story.title == "some title"
      assert story.url == "some url"
    end

    test "create_story/1 with valid data without url creates a story" do
      assert {:ok, %Story{} = story} = Posts.create_story(@ask_hn_attrs)
      assert story.by == "some by"
      assert story.descendants == 42
      assert story.id == 42
      assert story.score == 42
      assert story.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert story.title == "some title"
      assert story.url == nil
    end

    test "create_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_story(@invalid_attrs)
    end

    test "enforces unique ID" do
      assert {:ok, %Story{} = story} = Posts.create_story(@valid_attrs)
      assert {:error, changeset} = Posts.create_story(@valid_attrs)
    end


    test "update_story/2 with valid data updates the story" do
      story = story_fixture()
      assert {:ok, %Story{} = story} = Posts.update_story(story, @update_attrs)
      assert story.by == "some updated by"
      assert story.descendants == 43
      assert story.id == 43
      assert story.score == 43
      assert story.time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert story.title == "some updated title"
      assert story.url == "some updated url"
    end

    test "update_story/2 with invalid data returns error changeset" do
      story = story_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_story(story, @invalid_attrs)
      assert story == Posts.get_story!(story.id)
    end

    test "delete_story/1 deletes the story" do
      story = story_fixture()
      assert {:ok, %Story{}} = Posts.delete_story(story)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_story!(story.id) end
    end

    test "change_story/1 returns a story changeset" do
      story = story_fixture()
      assert %Ecto.Changeset{} = Posts.change_story(story)
    end
  end

  describe "comments" do
    alias WebHn.Posts.Comment

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Posts.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Posts.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Posts.create_comment(@valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Posts.update_comment(comment, @update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_comment(comment, @invalid_attrs)
      assert comment == Posts.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Posts.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Posts.change_comment(comment)
    end
  end
end
