defmodule EnvList do
  @moduledoc """
  A module that implements key-value database functionality
  as a list
  """
  def new() do [] end

  def add([], key, val) do [{key, val}] end
  def add([{key, _ } | map], key, val) do [{key, val}] ++ map end
  def add([h|t], key, value) do
    z = add(t, key, value)
    [h|z]
  end

  def lookup([], _) do nil end
  def lookup([{key, val} | _], key) do {key, val} end
  def lookup([_|t], key) do lookup(t, key) end


  def remove([], _) do [] end
  def remove([{key, _} | map], key ) do map end
  def remove([h|t], key) do
    z = remove(t, key)
    [h|z]
  end

end
