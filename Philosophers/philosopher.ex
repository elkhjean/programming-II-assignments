defmodule Philosopher do
  @dream 50
  @eat 200
  @stall 500
  @timeout 1000


  def start(hunger, str, right, left, name, ctrl) do
    philosopher = spawn_link(fn -> dreaming(hunger, str, right, left, name, ctrl) end)
  end


  defp dreaming(0, _, _, _, name, ctrl) do

    send(ctrl, :done)
    IO.puts("#{name} is done")
  end
  defp dreaming(hunger, 0, _, _, name, ctrl) do
    IO.puts("#{name} is starved to death, hunger is down to #{hunger}!")
    send(ctrl, :done)
  end
  defp dreaming(hunger, str, right, left, name, ctrl) do
    delay(@dream)
    wait_for_sticks(hunger, str, right, left, name, ctrl, make_ref())
  end


  defp eating(hunger, str, right, left, name, ctrl, ref) do
    IO.puts("#{name} is eating")
    delay(@eat)
    IO.puts("#{name} returned both chopsticks!")
    Chopstick.return(left, ref)
    Chopstick.return(right, ref)
    dreaming(hunger-1, str, right, left, name, ctrl)
  end


  defp wait_for_sticks(hunger, str, right, left, name, ctrl, ref) do
    IO.puts("#{name} is waiting, #{hunger} to go!")

    case Chopstick.request(left, ref) do
      :ok ->
        IO.puts("#{name} received left chopstick!")
        delay(@stall)

        case Chopstick.request(right, @timeout, ref)do
          :ok ->
            IO.puts("#{name} received both chopsticks!")
            eating(hunger-1, str, right, left, name, ctrl, ref)
          :no ->
            IO.puts("#{name} timeout!! right")
            Chopstick.return(left, ref)
        end
    end
    dreaming(hunger, str-1, right, left, name, ctrl)
  end


  defp delay(t), do: sleep(t)

  defp sleep(0), do: :ok
  defp sleep(t), do: :timer.sleep(Enum.random(1..t))
end
