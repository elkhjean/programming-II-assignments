defmodule Bench do
  @moduledoc """
  A module for benchmarking operations on tree structure
  """

  def bench(n) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark of map as a list and as a tree (loop: ~w) \n", [n])
    :io.format("~6.s~8.s~-36.s~-36.s~-36.s\n", ["n", "", "add", "lookup", "remove"])
    :io.format("~18.s~12.s~12.s~12.s~12.s~12.s~12.s~12.s~12.s\n", ["list", "tree", "map", "list", "tree", "map", "list", "tree", "map"])
    Enum.each(ls, fn (i) ->
      {i, tla, tta, tma, tll, ttl, tml, tlr, ttr, tmr} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f\n", [i,tla/(i*n), tta/(i*n), tma/(i*n), tll/(i*n), ttl/(i*n), tml/(i*n), tlr/(i*n), ttr/(i*n), tmr/(i*n)])
    end)

    :ok
  end

  def bench(i, n) do

    seq = Enum.map(1..i, fn(_) ->
      :rand.uniform(i) end)

    list = Enum.reduce(seq, EnvList.new(), fn(e, list) ->
      EnvList.add(list, e, :foo) end)

    seq = Enum.map(1..n, fn(_) ->
      :rand.uniform(i) end)

      {tla, tll, tlr}  = bench(seq, list, &EnvList.add/3, &EnvList.lookup/2, &EnvList.remove/2)
      {tta, ttl, ttr}  = bench(seq, list, &EnvTree.add/3, &EnvTree.lookup/2, &EnvTree.remove/2)
      {tma, tml, tmr}  = bench(seq, list, &Map.put/3, &Map.get/2, &Map.delete/2)

      {i, tla, tta, tma, tll, ttl, tml, tlr, ttr, tmr}
    end

  def bench(seq, list, f_add, f_lookup, f_remove) do

    {add, _} = :timer.tc(fn() ->
      Enum.reduce(seq, list, fn(e, list) ->
        f_add.(list, e, :foo) end)
      end)

    {lookup, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        f_lookup.(list, e) end)
      end)

    {remove, _} = :timer.tc(fn() ->
      Enum.reduce(seq, list, fn(e, list) ->
        f_remove.(list, e) end)
      end)

    {add, lookup, remove}
      end

end
