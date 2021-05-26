defmodule WebHn.Update do
  alias WebHn.Posts
  alias WebHn.Posts.Story
  alias WebHn.Repo

  defp http_client do
    Application.get_env(:web_hn, :http_client)
  end

  def get_id_list(url) do
    with {:ok, response} <- http_client().get(url),
         {:ok, id_list} <- Jason.decode(response.body),
         do: {:ok, id_list}
    end

  def get_details(id, incomplete_url, keywordmap) do
    url = ~s/#{incomplete_url}#{id}.json/
    with {:ok, response} <- http_client().get(url),
         {:ok, details} <- response.body 
            |> Jason.decode([keys: fn k -> WebHn.Update.change_keyword(k, keywordmap) end]),
         do: {:ok, details |> Map.update!("time", &DateTime.from_unix!/1)}
    end

  def get_details!(id, incomplete_url, keywordmap) do
    {:ok, details} = get_details(id, incomplete_url, keywordmap)
    details
  end

  def details_list(url, incomplete_url, keywordmap, n) do
    {:ok, id_list} = get_id_list(url)
    id_list |> Enum.slice(0, n) |> Enum.map(fn id -> get_details!(id, incomplete_url, keywordmap) end)
  end

  def change_keyword({k, v}, keywordmap) do
    case Map.fetch(keywordmap, k) do
      {:ok, newkey} ->
        {newkey, v}
      {:error} ->
        {k, v}
    end
  end

  def change_keyword(k, keywordmap) when not(is_tuple (k)) do
    case Map.fetch(keywordmap, k) do
      {:ok, newkey} ->
        newkey
      :error ->
        k
    end
  end

  def update_stories(url, incomplete_url, keywordmap, n) do
    details_list(url, incomplete_url, keywordmap, n) 
    |> Enum.map(fn attrs -> Story.changeset(%Story{}, attrs) 
      |> Repo.insert!(on_conflict: :replace_all, conflict_target: :id) end)
  end

  def details_to_struct(enumerable, keywordmap, output_struct) do
    key_fun = fn {k, v} -> change_keyword({k, v}, keywordmap) end
    struct(output_struct, Enum.map(enumerable, key_fun))
  end
end


