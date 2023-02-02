defmodule Env do
  @moduledoc """
  A module that implements key-value map functionality
  as a list
  """
  def new() do [] end

  def add(key, val, []) do [{key, val}] end
  def add(key, val, [{key, _ } | map]) do [{key, val}] ++ map end
  def add(key, val, [h|t]) do
    z = add(key, val, t )
    [h|z]
  end

  def lookup(_, []) do nil end
  def lookup(key, [{key, val} | _]) do {key, val} end
  def lookup(key, [_|t]) do lookup(key, t) end


  def remove([], env) do env end
  def remove([rmid | rmids], env) do
    env = rm(env, rmid)
    rmids = remove(rmids, env)
    rmids
  end
  def rm([], _) do [] end
  def rm([{key, _} | map], key) do map end
  def rm([h|t], key) do
    z = rm(t, key)
    [h|z]
  end

  def closure(ids, env) do
    List.foldr(ids, [], fn(id, acc) ->
      case acc do
        :error ->
          :error
        cls ->
          case lookup(id, env) do
            {id, value} ->
              [{id, value} | cls]

            nil ->
              :error
          end
      end
    end)
  end

  def args(param, strs, env) do
    List.zip([param, strs]) ++ env
  end

end
