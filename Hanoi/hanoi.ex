defmodule Hanoi do
  def hanoi(0, _, _, _) do [] end
  def hanoi(n,  src,  aux,  dest) do
    hanoi(n-1,  src,  dest,  aux) ++ [{:move,  src,  dest}] ++ hanoi(n-1,  aux,  src,  dest)
    end
end
