defmodule Bucket do

	def memo do
		IO.inspect("
			typically used to store a data structure such as a registry
			")
	end

	#the 3 basic functions of an agent
	def init(opts \\ []), do: Agent.start_link(fn -> %{} end, opts)
	def add(agent, key, value), do: Agent.update(agent, fn map -> Map.put(map, key, value) end)
	def get(agent, key), do: Agent.get(agent, fn map -> Map.get(map, key) end)

end