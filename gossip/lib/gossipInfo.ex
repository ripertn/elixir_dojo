defmodule GossipInfo do
  use GenServer

  # starting gossip
  def start_link(opt \\ []), do: GenServer.start_link(__MODULE__, opt)
  def init(opt), do: {:ok, {0}}

  # client side
  def increase(pid), do: GenServer.cast(pid, {:increase})

  # server side  
  def handle_cast({:increase}, {counter}), do: IO.inspect({:noreply, {counter+1}}, label: "NUMBER OF DEAD PROCESS")

end