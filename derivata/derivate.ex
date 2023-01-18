defmodule Derivate do
  @moduledoc """
  A module that implements functions for taking the derivate of
  an expression
  """

  @type literal() :: {:num, number()}
    | {:var, atom()}

  @type expr() :: literal()
    | {:add, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:exp, expr(), literal()}

  def derive({:num, _}, _) do
    # Derivative with non-variable argument always 0
    {:num, 0}
  end

  def derive({:var, v}, v) do
    # v-derivative with respect to v with exponent one always 1
    {:num, 1}
  end

  def derive({:var, _}, _) do
    # Derivate of variable with respect to different variable always 0
  end

  def derive({:add, left, right}, v) do
    # Sum rule
    {:add, derive(left, v), derive(right, v)}
  end

  def derive({:mul, left, right}, v) do
    # Product rule
    {:add,
    {:mul, derive(left, v), right},
    {:mul, derive(right, v), left}}
  end

  def derive({:exp, b, e}, v) do
    #power rule
    {:mul, {:mul, e, {:exp, b, {:add, e, -1}}}, derive(b, v)}
  end


  def simplify_num({:num, n}) do {:num, n} end
  def simplify_num({:var, v}) do {:var, v} end


end
