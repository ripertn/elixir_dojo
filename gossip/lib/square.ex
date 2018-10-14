defmodule Square do
  use GenServer

  # starting gossip
  def start_link(watcher \\ nil), do: GenServer.start_link(__MODULE__, watcher)
  def init(watcher), do: {:ok, {[],0,watcher}}
  def launch(n, watcher \\ nil) do
    crew = (for _ <- 0..n, do: elem(Gossip.start_link(watcher),1))
    Enum.map(crew, &(add_crew(&1,crew--[&1])))
    crew
      |> hd()
      |> Square.send_msg()
  end 


  # client side
  def add_crew(pid, crew), do: GenServer.cast(pid, {:add_crew, crew})
  def rcv_msg(pid, msg \\ ""), do: GenServer.cast(pid, {:rcv_msg, msg})
  def send_msg(pid, msg \\ ""), do: GenServer.cast(pid, {:send_msg, msg})


  # server side  
  def handle_info(:send) do   
  end

  def handle_cast({:add_crew, crew}, {_, msg_counter, watcher}), do:
      {:noreply, {crew, msg_counter, watcher}}
  
  def handle_cast({:rcv_msg, _msg}, {crew, msg_counter, watcher}) do
    if msg_counter < 10 do
      send_msg(self())
    else
      GossipInfo.increase(watcher)
      IO.inspect(self(), label: "exit of:") |> Process.exit(:normal)
    end
    {:noreply, {crew, msg_counter+1, watcher}}
  end
  
  def handle_cast({:send_msg, _msg}, {[], _, _}), do: Process.exit(self(), "alone in the crew")
  def handle_cast({:send_msg, _msg}, {crew, msg_counter, watcher}=state) do
    rcpt = Enum.random(crew) ## recipient of the msg
    if Process.alive?(rcpt) do
      IO.inspect({self(),rcpt}, label: "send message from/to")
      rcv_msg(rcpt, "ChitChat")
      send_msg(self())
      {:noreply, state}
    else
      IO.inspect(rcpt, label: "recipient is dead:")
      {:noreply, {crew -- [rcpt], msg_counter, watcher}}
    end
  end

  def ticker(pid) do
    send(pid, :write)
    Task.start( fn -> 
      Process.sleep(1000)
    end)
    
  end
end