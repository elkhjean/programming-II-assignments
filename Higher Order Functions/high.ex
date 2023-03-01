defmodule High do
@moduledoc """
Excercise in higher order functions
"""


  def double([]) do [] end
  def double([h|t]) do
    [h*2|double(t)]
  end



  def five([]) do [] end
  def five([h|t]) do
    [h+5|five(t)]
  end



  def animal([]) do [] end
  def animal([h|t]) do
    case :dog do
      ^h ->
        [:fido | animal(t)]
      _ ->
        [h | animal(t)]
    end
  end



  def double_five_animal([], _) do [] end
  def double_five_animal([h|t], op ) do
    case op do
      :double -> double([h|t])
      :five -> five([h|t])
      :animal -> animal([h|t])
    end
  end



  def apply_to_all([], _) do [] end
  def apply_to_all([h|t], fun) do
    [fun.(h)|apply_to_all(t, fun)]
  end



  def sum([]) do 0 end
  def sum([h|t]) do
    h+sum(t)
  end



  def prod([]) do 0 end
  def prod([h|t]) do
    h*prod(t)
  end



  def fold_right([], base, _) do base end
  def fold_right([h|t], base, fun) do
    fun.(h, fold_right(t, base, fun))
  end



  def fold_left([], acc, _) do acc end
  def fold_left([h|t], acc, fun) do
    fold_left(t, fun.(h, acc), fun)
  end


  def odd([]) do [] end
  def odd([h|t]) do
    if rem(h,2) == 1 do
      [h|odd(t)]
    else
      odd(t)
    end
  end



  def filter([], _) do [] end
  def filter([h|t], fun) do
    if fun.(h) do
      [h|filter(t, fun)]
    else
      filter(t, fun)
    end
  end

end
