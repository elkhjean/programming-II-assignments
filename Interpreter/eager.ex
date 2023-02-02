defmodule Eager do
@moduledoc """
The following code is in large part inspired by example code
provided in assignment description for course assignment.
"""
@doc """
  Evaluation of expressions
"""
  def eval_expr({:atm, id}, _env) do
    {:ok, id}
  end
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end
  def eval_expr({:cons, str1, str2}, env) do
    case eval_expr(str1, env) do
       :error ->
        :error
        {:ok, ts1} ->
          case eval_expr(str2, env) do
           :error  ->
            :error
           {:ok, ts2} ->
              {:ok, {ts1, ts2}}
          end
    end
  end
  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end

  def eval_expr({:lambda, param, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, param, seq, closure}}
    end
  end
  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, param, seq, closure}} ->
        case eval_args(args, env) do
          :error->
            :error
          {:ok, strs} ->
            env = Env.args(param, strs, closure)
            eval_seq(seq, env)
        end
    end
  end

  def eval_expr({:fun, id}, _env) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, Env.new()}}
    end

  @doc """
  Evaluation of a list of arguments (expressions)
  """
  def eval_args(args, env) do
    eval_args(args, env, [])
  end

  def eval_args([], _, strs) do {:ok, Enum.reverse(strs)}  end
  def eval_args([expr | exprs], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(exprs, env, [str|strs])
    end
  end

  @doc """
  Evaluation for clauses
"""
  def eval_cls([], _, _) do
    :error
  end
  def eval_cls([{:clause, pttrn, seq} | cls], str, env) do
    case eval_match(pttrn, str, eval_scope(pttrn, env)) do
      :fail ->
        eval_cls(cls, str, env)
      {:ok, env} ->
        eval_seq(seq, env)
    end
  end

@doc """
  Evaluation for matching
"""
  def eval_match(:ignore, _, env) do
    {:ok, env}
  end
  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end
  def eval_match({:cons, str1, str2}, {at1, at2}, env) do
    case eval_match(str1, at1, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(str2, at2, env)
    end
  end
  def eval_match(_, _, _) do
    :fail
  end

@doc """
Extraction of variable included in a pattern from environment
"""
  def extract_vars(pattern) do
    extract_vars(pattern, [])
  end

  def extract_vars({:atm, _}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do
    [var | vars]
  end
  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end

@doc """
Sets the scope of a function by removing variables used in
pattern from environment
"""
  def eval_scope(pat, env) do
    Env.remove(extract_vars(pat), env)
  end

@doc """
Evaluates a sequence
"""
  def eval_seq([expr], env) do
    eval_expr(expr, env)
  end
  def eval_seq([{:match, pttrn, expr} | seq], env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        env = eval_scope(pttrn, env)

        case eval_match(pttrn, str, env) do
          :fail ->
            :error
          {:ok, env} ->
            eval_seq(seq, env)
        end
    end
  end
@doc """

"""
  def eval(seq) do
    eval_seq(seq, Env.new())
  end

end
