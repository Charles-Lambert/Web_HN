defmodule WebHn.Update.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  
  def start(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    child = [{WebHn.Update.Trigger, []}]
    Supervisor.init(child, [strategy: :one_for_one])
  end
end

