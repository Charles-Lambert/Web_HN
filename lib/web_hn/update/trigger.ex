defmodule WebHn.Update.Trigger do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end 


  def init(:ok) do
    Process.send(self(), :trigger, [])

    {:ok, []}
  end

  def handle_info(:trigger, opts) do
    list_url=Application.fetch_env!(:web_hn, :list_url)
    story_url=Application.fetch_env!(:web_hn, :story_url)
    WebHn.Update.update_stories(list_url, story_url, %{}, 10)
    Process.send_after(self(), :trigger, 60*1000, opts)
    {:noreply, opts}
  end
end
