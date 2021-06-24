defmodule WebHnWeb.CommentController do
  use WebHnWeb, :controller

  alias WebHn.Posts
  alias WebHn.Posts.Comment

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params) do
    comments = Posts.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, %{"parent_story" => parent_story_id, "parent_comment" => parent_comment}, _current_user) do
    parent_story = Posts.get_story!(parent_story_id)
    changeset = Posts.change_comment(%Comment{})
    render(conn, "new.html", %{changeset: changeset, parent_story: parent_story, parent_comment: parent_comment})
  end

  def new(conn, %{"parent_story" => parent_story_id}, _current_user) do
    parent_story = Posts.get_story!(parent_story_id)
    changeset = Posts.change_comment(%Comment{parent_story: parent_story_id}, %{parent_story: parent_story_id})
    render(conn, "new.html", %{changeset: changeset, parent_story: parent_story, parent_comment: nil})
  end

  def create(conn, %{"comment" => comment_params}, current_user) do 
    #%{"comment" => comment_params, "parent_story" => parent_story} = params
    #parent_params = case Map.fetch(params, "parent_comment") do
    #  {:ok, parent_comment} -> 
    #    %{parent_story: parent_story, parent_comment: parent_comment}
    #  :derror -> 
    #    %{parent_story: parent_story}
    #end

    case Posts.create_comment(current_user, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    comment = Posts.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Posts.get_comment!(id)
    changeset = Posts.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Posts.get_comment!(id)

    case Posts.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Posts.get_comment!(id)
    {:ok, _comment} = Posts.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.comment_path(conn, :index))
  end
end
