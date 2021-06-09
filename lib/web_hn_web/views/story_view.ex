defmodule WebHnWeb.StoryView do
  use WebHnWeb, :view
  alias Phoenix.HTML

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


  def ph_comments() do
    dave = %{id: 1, user: "dave", body: "this is a reply to a reply", children: []}
    carol = %{id: 2, user: "carol", body: "this is another reply", children: [dave]}
    bob = %{id: 3, user: "bob", body: "this is a reply", children: []}
    alice = %{id: 4, user: "alice", body: "this is a top-level comment", children: [bob, carol]}
    eve = %{id: 5, user: "eve", body: "this is another top-level comment", children: []}
    [alice, eve]
  end

  def ph_comment_list() do
    dave = %{id: 1, user: "dave", body: "this is a reply to a reply", parent: 2, children: []}
    carol = %{id: 2, user: "carol", body: "this is another reply", parent: 4, children: []}
    bob = %{id: 3, user: "bob", body: "this is a reply", parent: 4, children: []}
    alice = %{id: 4, user: "alice", body: "this is a top-level comment", parent: nil, children: []}
    eve = %{id: 5, user: "eve", body: "this is another top-level comment", parent: nil, children: []}
    [eve, alice, bob, carol, dave]
  end

  def build_tree(comment_list, tree) do # cannot accept child before parent (forward chronological order recommended)
    case comment_list do
      [] -> 
        tree
      [head|tail] ->
        build_tree(tail, add_to_tree(head, tree))
    end
  end

  def add_to_tree(comment, tree) do 
    case comment.parent do
      nil -> [comment | tree] #add top level comment to tree
      parent ->
        case tree do
          [] -> [] #hit the bottom of the tree (past a leaf node)
          [node = %{id: ^parent} | tail] -> #found the parent comment
            [%{node | children: [comment | node.children]} | tail] #prepend child to comment list. stop recursing
          [head | tail] ->
            [%{head | children: add_to_tree(comment, head.children)} | add_to_tree(comment, tail)] #recurse down and across tree
        end
    end
  end


end
