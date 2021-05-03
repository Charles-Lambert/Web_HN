defmodule WebHnWeb.StoryView do
  use WebHnWeb, :view
  alias Phoenix.HTML

  def foo(x) do
    x |> Enum.take_random(5) |> Enum.map(&Map.get(&1, :by))
  end
  
  def sort(list, by, descending?) do
    fun = if descending? == "true", do: &>=/2, else: &<=/2
    list |> Enum.sort_by(fn item -> Map.get(item, string_to_atom(by, :time)) end, fun)
  end

  defp string_to_atom(str, default) do
    try do
      String.to_existing_atom(str)
    rescue
      ArgumentError -> default
    end
  end
  
  def sortlink(new_sort_by, cur_sort_by, descending, conn) do
    if new_sort_by == cur_sort_by do
      arrow = if descending == "true", do: "\u0020\u25BE", else: "\u0020\u25B2"
      link(new_sort_by <> arrow, 
        to: Routes.story_path(conn, :index, %{sortby: new_sort_by, descending: descending=="false"}))
    else
      link(new_sort_by, to: Routes.story_path(conn, :index, %{sortby: new_sort_by, descending: false}))
    end
  end
    
  def linkfun (conn) do
    link "By", to: Routes.story_path(conn, :index, %{sortby: "by", descending: false})
  end


  def render() do
    
  end
end
