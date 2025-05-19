defmodule Defo do
  @moduledoc """
    #{__MODULE__} is handy to create function with default options

  defmodule Test do
    use Defo, default_opts: [log?: true]
    require Logger

    defo my_function(k, opts \\ []) do
      if opts[:log?], do: Logger.info("logging on demand !")
      k * k
    end
  end

  Test.my_function(2, [])
  Test.my_function(2, [log?: false])
  """

  defmacro __using__(opts) do
    quote do
      import Defo
      @opts unquote(opts[:default_opts])
    end
  end



  defmacro defo({f_name, _meta, args}, body_block) do
    last_arg_name = case List.last(args) do
      {{:\\,_, [var,_]}} -> var
      var -> var
    end

    quote do
      def unquote(f_name)(unquote_splicing(args)) do
        unquote(last_arg_name) = Keyword.merge(@opts, unquote(last_arg_name))
        unquote(body_block[:do])
      end
    end
  end
end
