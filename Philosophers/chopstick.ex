defmodule Chopstick do

  def start() do
    stick = spawn_link(fn -> available() end)
  end


  def available() do
    receive do
      {from, :request, ref} ->
        send(from, {:granted, ref})
        gone(ref)
      :quit -> :ok
    end
  end


  def gone(ref) do
    receive do
      {:return, ^ref} -> available()
      :quit -> :ok
    end
  end


  def request(stick, timeout, ref) do
    send(stick, {self(), :request, ref})
    wait(timeout, ref)
  end
  def request(stick, ref) do
    send(stick, {self(), :request, ref})
    wait(ref)
  end



  def wait(timeout, ref) do
    receive do
      {:granted, ^ref} -> :ok
      {:granted, _} -> wait(timeout, ref)
      after timeout -> :no
    end
  end
  def wait(ref) do
    receive do
      {:granted, ^ref} -> :ok
      {:granted, _} -> wait(ref)
    end
  end


  def return(stick, ref) do
    send(stick, {:return, ref})
  end


  def quit(stick) do
    send(stick, :quit)
  end

end
