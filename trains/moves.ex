defmodule Moves do
  @type wagon :: atom
  @type train :: [wagon | train]
  @type state :: {train, train, train}
  @type move :: {:one, integer}
    | {:two, integer}
  @type moves :: [move | moves]
  @type sequence :: [state | sequence]


  @spec single(move, state) :: state
  def single({_, 0}, state) do state end

  def single({:one, n}, {track, one, two}) when n > 0 do
    {k, rem, taken} = Train.main(track, n)
    {rem, Train.append(taken, one), two}
  end

  def single({:two, n}, {track, one, two}) when n > 0 do
    {k, rem, taken} = Train.main(track, n)
    {rem, one, Train.append(taken, two)}
  end

  def single({:one, n}, {track, one, two}) when n < 0 do
    {Train.append(track, Train.take(one, -n)), Train.drop(one, -n), two}
  end

  def single({:two, n}, {track, one, two}) when n < 0 do
    {Train.append(track, Train.take(two, -n)), one, Train.drop(two, -n)}
  end

  @spec sequence(moves, state) :: sequence
  def sequence([], state) do [state | []] end
  def sequence([h|t], state) do
    [state | sequence(t, single(h, state))]
  end

end
