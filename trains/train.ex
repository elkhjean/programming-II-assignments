defmodule Train do
  @type wagon :: atom
  @type train :: [wagon | train]

  @spec take(train, integer) :: train
  def take([], _) do [] end
  def take(_, 0)do [] end
  def take([h | t], n) do
    [h | take(t, n-1)]
  end

  @spec drop(train, integer) :: train
  def drop([], _) do [] end
  def drop([h | t], 0)do [h | t] end
  def drop([_h | t], n) do
    drop(t, n-1)
  end

  @spec append(train, train) :: train
  def append([], train) do train end
  def append([h|t], train) do [h|append(t,train)] end

  @spec member(train, wagon) :: boolean
  def member([h | _t], h) do true end
  def member([_h | []], _w) do false end
  def member([_h | t], w) do
    member(t, w)
  end

  @spec position(train, wagon) :: integer
  def position(train, w) do
    position(train, w, 1)
  end
  def position([h | _t], h, count) do count end
  def position([_h | t], w, count) do
    position(t, w, count + 1)
  end

  @spec split(train, wagon) :: {train, train}
  def split([h | t], h) do {[] ,t} end
  def split([h | t], w) do
    {nxt, rest} = split(t, w)
    {[h|nxt], rest}
  end

  @spec main(train, integer) :: {integer, train, train}
  def main([], n) do {n, [], []} end
  def main([h | t], n) do
    {k, rem, taken} = main(t, n)
    case k>0 do
      true ->
        {k-1, rem, [h|taken]}
      false ->
        {k, [h|rem], taken}
    end
  end
end
