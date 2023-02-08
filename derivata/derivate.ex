defmodule Derivate do
  @moduledoc """
  A module that implements functions for taking the derivate of
  an expression
  """

  @type literal() ::
      {:num, number()}
    | {:var, atom()}

  @type expr() ::
      literal()
    | {:add, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:exp, expr(), literal()}
    | {:ln, expr()}
    | {:sin, expr()}
    | {:sqrt, expr()}
    | {:div, expr()}

  def derive({:num, _}, _) do
    # Derivative of constant always 0
    {:num, 0}
  end

  def derive({:var, v}, v) do
    # v-derivative with respect to v with exponent one always 1
    {:num, 1}
  end

  def derive({:var, _}, _) do
    # Derivate of variable with respect to different variable always 0
    {:num, 0}
  end

  def derive({:add, f, g}, v) do
    # Sum rule
    {:add, derive(f, v), derive(g, v)}
  end

  def derive({:mul, f, g}, v) do
    # Product rule
    {:add,
    {:mul, derive(f, v), g},
    {:mul, derive(g, v), f}}
  end

  def derive({:exp, b, {:num, e}}, v) do
    # Power rule with chain rule (inner derivate * outer)
    {:mul, {:mul, {:num, e}, {:exp, b, {:num, e-1}}}, derive(b, v)}
  end

  def derive({:ln, e}, v) do
    # Log rule
    {:mul, {:exp, e, {:num, -1}}, derive(e, v)}
  end

  def derive({:sin, e}, v) do
    # Sin rule with chain rule
    {:mul, {:cos, e}, derive(e, v)}
  end

  def derive({:sqrt, e}, v) do
    # Sqrt rule
    derive({:exp, e, {:num, 0.5}}, v)
  end

  def derive({:div, f, g}, v) do
    # Quotient rule
    {:mul, {:add, {:mul, derive(f, v), g}, {:mul, {:mul, derive(g, v), f}, {:num, -1}}}, {:exp, g, {:num, -2}}}
  end

  def formatted_print({:num, n}) do "#{n}" end
  def formatted_print({:var, v}) do "#{v}" end
  def formatted_print({:add, f, g}) do "(#{formatted_print(f)} + #{formatted_print(g)})" end
  def formatted_print({:mul, f, g}) do "#{formatted_print(f)} * #{formatted_print(g)}" end
  def formatted_print({:exp, b, e}) do "(#{formatted_print(b)}) ^ #{formatted_print(e)}" end
  def formatted_print({:cos, e}) do "cos(#{formatted_print(e)})" end
  def formatted_print({:ln, e}) do "ln(#{formatted_print(e)})" end

  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end
  def simplify({:ln, e}) do {:ln, e} end
  def simplify({:add, f, g}) do
    simplify_add(simplify(f), simplify(g))
  end
  def simplify({:mul, f, g}) do
    simplify_mul(simplify(f), simplify(g))
  end
  def simplify({:exp, f, g}) do
    simplify_exp(simplify(f), simplify(g))
  end

  def simplify_add({:num, 0}, g) do g end
  def simplify_add(f, {:num, 0}) do f end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add({:var, v}, {:var, v}) do {:mul, {:num, 2}, {:var, v}} end
  def simplify_add(f, g) do {:add, f, g} end

  def simplify_mul({:mul, {:num, n}, {:add, {:var, v1}, {:var, v2}}}) do {:add, {:mul, n, v1}, {:mul, n, v2}} end
  def simplify_mul({:mul, {:add, {:var, v1}, {:var, v2}}, {:num, n}}) do {:add, {:mul, n, v1}, {:mul, n, v2}} end
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:num, 1}, g) do g end
  def simplify_mul(f, {:num, 1}) do f end
  def simplify_mul({:var, v}, {:var, v}) do {:exp, {:var, v}, {:num, 2}} end
  def simplify_mul({:var, v}, {:exp, v, n}) do {:exp, {:var, v}, {:num, n+1}} end
  def simplify_mul({:exp, v, n}, {:var, v}) do {:exp, {:var, v}, {:num, n+1}} end
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e}) do
    {:mul, {:num, n1*n2}, e}
  end
  def simplify_mul({:num, n1}, {:mul, e, {:num, n2}}) do
    {:mul, {:num, n1*n2}, e}
  end
  def simplify_mul({:mul, {:num, n1}, e}, {:num, n2}) do
    {:mul, {:num, n1*n2}, e}
  end
  def simplify_mul({:mul, e, {:num, n1}}, {:num, n2}) do
    {:mul, {:num, n1*n2}, e}
  end
  def simplify_mul(f, g) do {:mul, f, g} end

  def simplify_exp(_, {:num, 0}) do  1 end
  def simplify_exp(b, {:num, 1}) do  b end
  def simplify_exp({:num, b}, {:num, e}) do b ** e end
  def simplify_exp(b, e) do {:exp, b, e} end

  def test1() do
    test =
      {:mul, {:num, 5}, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 5}}}, {:mul, {:num, 3}, {:exp, {:var, :x}, {:num, 3}}}}}
    der = derive(test, :x)
    simple_derivate = simplify(der)

    IO.write("expression: #{formatted_print(test)}\n")
    IO.write("derivative: #{formatted_print(der)}\n")
    IO.write("simplified: #{formatted_print(simple_derivate)}\n")
  end

  def test2() do
    test =
      {:add, {:ln, {:mul, {:num, 2}, {:var, :x }}}, {:mul, {:num, 3}, {:add, {:exp, {:var, :x}, {:num, 4}}, {:num, 5}}}}
    der = derive(test, :x)
    simple_derivate = simplify(der)

    IO.write("expression: #{formatted_print(test)}\n")
    IO.write("derivative: #{formatted_print(der)}\n")
    IO.write("simplified: #{formatted_print(simple_derivate)}\n")
  end


end
