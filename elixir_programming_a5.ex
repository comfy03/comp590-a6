defmodule ElixirProgrammingA5 do
  # Start the chain by spawning the servers and initiating the message loop
  def start do
    serv3_pid = spawn(__MODULE__, :serv3, [0]) # Start serv3 with accumulator 0
    serv2_pid = spawn(__MODULE__, :serv2, [serv3_pid]) # Start serv2 and pass serv3 PID
    serv1_pid = spawn(__MODULE__, :serv1, [serv2_pid, self()]) # Start serv1 and pass serv2 PID and caller PID

    IO.puts("PIDs: Serv1 = #{inspect(serv1_pid)}, Serv2 = #{inspect(serv2_pid)}, Serv3 = #{inspect(serv3_pid)}")
    message_loop(serv1_pid)
    {serv1_pid, serv2_pid, serv3_pid}
  end

  # Interactive message loop
  defp message_loop(serv1_pid) do
    IO.write("Enter a message (or 'all_done' to quit): ")
    input = IO.gets("") |> String.trim()

    case input do
      "all_done" ->
        IO.puts("Stopping...")

      "update" ->
        send(serv1_pid, {:update, self()})
        receive do
          {:new_pid, new_pid} ->
            IO.puts("Switched to new Serv1 PID: #{inspect(new_pid)}")
            message_loop(new_pid)
        after
          5000 ->
            IO.puts("Update failed to produce a new PID.")
            message_loop(serv1_pid)
        end

      _ ->
        # Evaluate as an Elixir term
        try do
          term = Code.eval_string(input) |> elem(0)
          send(serv1_pid, term)
          message_loop(serv1_pid)
        rescue
          _ ->
            IO.puts("Invalid input format, try again.")
            message_loop(serv1_pid)
        end
    end
  end

  # serv1: handles arithmetic operations and passes unhandled messages to serv2
  def serv1(serv2_pid, loop_pid) do
    receive do
      {:update, caller_pid} ->
        IO.puts("(serv1) Updating to newest version. Old PID = #{inspect(self())}")
        new_pid = spawn(__MODULE__, :serv1, [serv2_pid, caller_pid])
        IO.puts("(serv1) New instance created with PID = #{inspect(new_pid)}")
        send(caller_pid, {:new_pid, new_pid})
        exit(:normal)

      {:add, x, y} ->
        IO.puts("(serv1) Add #{x} + #{y} = #{x + y}")
        serv1(serv2_pid, loop_pid)

      {:sub, x, y} ->
        IO.puts("(serv1) Subtract #{x} - #{y} = #{x - y}")
        serv1(serv2_pid, loop_pid)

      :halt ->
        send(serv2_pid, :halt)
        IO.puts("(serv1) Halting...")

      other ->
        send(serv2_pid, other)
        serv1(serv2_pid, loop_pid)
    end
  end

  # serv2: handles lists of numbers and passes unhandled messages to serv3
  def serv2(serv3_pid) do
    receive do
      :update ->
        IO.puts("(serv2) Updating to newest version. Old PID = #{inspect(self())}")
        new_pid = spawn(__MODULE__, :serv2, [serv3_pid])
        IO.puts("(serv2) New instance created with PID = #{inspect(new_pid)}")
        exit(:normal)

      [h | t] when is_integer(h) ->
        sum = Enum.sum(Enum.filter([h | t], &is_number/1))
        IO.puts("(serv2) Sum of list: #{sum}")
        serv2(serv3_pid)

      :halt ->
        send(serv3_pid, :halt)
        IO.puts("(serv2) Halting...")

      other ->
        send(serv3_pid, other)
        serv2(serv3_pid)
    end
  end

  # serv3: handles errors and keeps track of unhandled messages
  def serv3(unhandled_count) do
    receive do
      :update ->
        IO.puts("(serv3) Updating to newest version. Old PID = #{inspect(self())}")
        new_pid = spawn(__MODULE__, :serv3, [unhandled_count])
        IO.puts("(serv3) New instance created with PID = #{inspect(new_pid)}")
        exit(:normal)

      {:error, reason} ->
        IO.puts("(serv3) Error: #{inspect(reason)}")
        serv3(unhandled_count)

      :halt ->
        IO.puts("(serv3) Halting... Total unhandled messages: #{unhandled_count}")

      other ->
        IO.puts("(serv3) Not handled: #{inspect(other)}")
        serv3(unhandled_count + 1)
    end
  end
end
