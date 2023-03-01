
defmodule Carlo do
@moduledoc """
Implementation of the monte carlo simulation to estimate pi
"""


  def dart(r) do
    import :math, only: [pow: 2]
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    pow(r, 2) > pow(x, 2) + pow(y, 2)
  end


  def round(0, _, a) do a end
  def round(k, r, a) do
    if dart(r) do
      round(k-1, r, a+1)
    else
      round(k-1, r, a)
    end
  end


  def rounds(k, r)  do
    a = round(1000, r, 0)
    rounds(k, 1000, r, a)
  end

  def rounds(0, n, _, a) do 4*a/n end
  def rounds(k, n, r, a) do
    a = round(n, r, a)
    n = n*2
    pi = 4*a/n
    :io.format(" n = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [n, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    rounds(k-1, n, r, a)
  end

  def leibniz() do
    4 * Enum.reduce(0..100000000, 0, fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)
  end

end
