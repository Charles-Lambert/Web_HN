defmodule WebHnWeb.CommentController do
  use WebHnWeb, :controller

  alias WebHn.Posts
  alias WebHn.Posts.Comment

  def index(conn, _params) do
    comments = Posts.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, %{"story" => story, "parent" => parent}) do
    changeset = Posts.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset, story: story, parent: parent)
  end

  def new(conn, %{"story" => story}) do
    changeset = Posts.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset, story: story)
  end

  def create(conn, %{"comment" => comment_params}) do
    case Posts.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
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
