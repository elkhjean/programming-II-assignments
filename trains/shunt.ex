defmodule Shunt do
  @type wagon :: atom
  @type train :: [wagon | train]
  @type state :: {train, train, train}
  @type move :: {:one, integer}
    | {:two, integer}
  @type moves :: [move | moves]
  @type sequence :: [state | sequence]


  @spec find(train, train) :: moves
  def find([], []) do [] end
  def find(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | find(Train.append(ts, hs), ys)]
  end

  @spec few(train, train) :: moves
  def few([], []) do [] end
  def few(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    case hn do
      0 ->
        few(Train.append(hs, ts), ys)
      _ ->
        [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | few(Train.append(ts, hs), ys)]
    end
  end

  @spec compress(moves) :: moves
  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end

  defp rules([]) do [] end
  defp rules([{_, 0} | t]) do rules(t) end
  defp rules([{x, n} | [{x, m} | t]]) do rules([{x, n+m} | t]) end
  defp rules([h | t]) do [h | rules(t)] end

end
