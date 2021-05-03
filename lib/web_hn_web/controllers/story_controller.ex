defmodule WebHnWeb.StoryController do
  use WebHnWeb, :controller

  alias WebHn.Posts
  alias WebHn.Posts.Story

  def index(conn, params) do
    stories = Posts.list_stories()
    render(conn, "index.html", stories: stories, sortby: Map.get(params, "sortby"), descending: Map.get(params, "descending"))
  end

  def new(conn, _params) do
    changeset = Posts.change_story(%Story{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"story" => story_params}) do
    case Posts.create_story(story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story created successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    story = Posts.get_story!(id)
    render(conn, "show.html", story: story)
  end

  def edit(conn, %{"id" => id}) do
    story = Posts.get_story!(id)
    changeset = Posts.change_story(story)
    render(conn, "edit.html", story: story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "story" => story_params}) do
    story = Posts.get_story!(id)

    case Posts.update_story(story, story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story updated successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", story: story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    story = Posts.get_story!(id)
    {:ok, _story} = Posts.delete_story(story)

    conn
    |> put_flash(:info, "Story deleted successfully.")
    |> redirect(to: Routes.story_path(conn, :index))
  end
end
