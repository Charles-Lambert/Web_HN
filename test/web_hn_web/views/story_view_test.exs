defmodule WebHnWeb.StoryViewTest do
  use WebHnWeb.ConnCase, async: true 

  alias WebHnWeb.StoryView

    describe "sort/3" do
      @story_1 %{by: "Alice", title: "Zanzibar", url: "example.com", time: ~U[2000-01-01 01:00:00Z], id: 1, score: 0, descendants: 0}
      @story_2 %{by: "Bob", title: "Nectar", url: nil, time: ~U[2010-10-10 10:10:00Z], id: 5, score: 2, descendants: 2} 
      @story_3 %{by: "Carol", title: "Alfa", url: "zzz.example.com", time: ~U[2220-12-12 23:23:00Z], id: 10, score: 10, descendants: 1}
      test "by author ascending" do
        assert  [@story_1, @story_2, @story_3] |> StoryView.sort(:by, "true") == [@story_3, @story_2, @story_1]
        assert  [@story_1, @story_2, @story_3] |> StoryView.sort(:url, "false") == [@story_1, @story_2, @story_3]
    end
  end
end 
