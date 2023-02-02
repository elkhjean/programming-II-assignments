defmodule InTest do
  def matchtest() do
    seq = [{:match, {:var, :foo}, {:atm, :hello}}, {:match, {:var, :bar}, {:atm, :world}}, {:cons, {:var, :foo}, {:var, :bar}}]
    Eager.eval(seq)
  end
  def casetest() do
    seq = [{:match, {:var, :x}, {:atm, :b}}, {:case, {:var, :x}, [{:clause, {:atm, :b}, [{:atm, :ops}]}, {:clause, {:atm, :a}, [{:atm, :yes}]}]}]
    Eager.eval(seq)
  end
  def lambdatest() do
    seq = [{:match, {:var, :x}, {:atm, :a}}, {:match, {:var, :f}, {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}}, {:apply, {:var, :f}, [{:atm, :b}]}]
    Eager.eval(seq)
  end
  def prgmtest() do
    seq = [{:match, {:var, :x}, {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}}, {:match, {:var, :y}, {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}}, {:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}]
    Eager.eval(seq)
  end
end
