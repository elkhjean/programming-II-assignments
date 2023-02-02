defmodule Evaluate do

  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, literal(), literal()}

  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | literal()


  def new_env() do %{} end
  def new_env({key, val}) do %{key => val} end
  def new_env({key, val}, map) do Map.put(map, key, val) end

  def fetch_bind(map, key) do map[key] end

  def eval({:num, n}, _env) do {:num, n} end
  def eval({:var, v}, env) do {:num, fetch_bind(env, v)} end
  def eval({:q, n, m}, _env) do
    gcd = Integer.gcd(n, m)
    {:q, div(n, gcd), div(m, gcd)}
  end
	def eval({:add, a, b}, env) do add(a, b, env) end
	def eval({:sub, a, b}, env) do sub(a, b, env) end
	def eval({:mul, a, b}, env) do mul(a, b, env) end
	def eval({:div, a, b}, env) do div(a, b, env) end

	def add({:num, a}, {:num, b}, _) do {:num, a+b} end
	def add({:num, a}, {:q, n, m}, _) do {:q, a*m+n, m} end
	def add({:q, n, m}, {:num, a}, _) do {:q, a*m+n, m} end
  def add({:q, a, m}, {:q, b, m}, _) do {:q, a+b, m} end
	def add(a, b, env) do {:add, eval(a, env), eval(b, env)} end

	def sub({:num, a}, {:num, b}, _) do {:num, a-b} end
	def sub({:num, a}, {:q, n, m}, _) do {:q, (a*m) - n, m} end
	def sub({:q, n, m}, {:num, a}, _) do {:q, n - (a*m), m} end
  def sub({:q, a, m}, {:q, b, m}, _) do {:q, a-b, m} end
	def sub(a, b, env) do {:sub, eval(a, env), eval(b, env)} end

	def mul({:num, a}, {:num, b}, _) do {:num, a*b} end
	def mul({:num, a}, {:q, n, m}, _) do {:q, n*a, m} end
	def mul({:q, n, m}, {:num, a}, _) do {:q, n*a, m} end
  def mul({:q, a, b}, {:q, c, d}, _) do {:q, a*c, b*d} end
	def mul(a, b, env) do {:mul, eval(a, env), eval(b, env)} end

	def div({:num, a}, {:num, b}, _) do {:q, a, b} end
	def div({:num, a}, {:q, n, m}, _) do {:q, m * a, n} end
	def div({:q, n, m}, {:num, a}, _) do {:q, n, m * a} end
  def div({:q, a, b}, {:q, c, d}, _) do {:q, a*d, c*b} end
	def div(a, b, env) do {:div, eval(a, env), eval(b, env)} end

  def test1() do
    #((8/3) + x) / ((5/2) - y)
    environment = new_env()
    environment = new_env({:x, 8}, environment)
    environment = new_env({:y, 2}, environment)
    eval({:div, {:add, {:q, 8, 3}, {:var, :x}}, {:sub, {:q, 5, 2}, {:var, :y}}}, environment)
  end

  def test2() do
    #(5/7)*x + (y - ((4/5)*7)
    environment = new_env()
    environment = new_env({:x, 9}, environment)
    environment = new_env({:y, 4}, environment)
    eval({:add, {:mul, {:q, 5, 7}, {:var, :x}}, {:sub, {:var, :y}, {:mul, {:q, 4, 5}, {:num, 7}}}}, environment)
  end

  def test3() do
    environment = new_env()
    environment = new_env({:x, 9}, environment)
    environment = new_env({:y, 4}, environment)
    eval({:sub, {:mul, {:q, 5, 7}, {:q, 10, 6}}, {:div, {:q, 6, 9}, {:q, 100, 32}}}, environment)
  end

end
