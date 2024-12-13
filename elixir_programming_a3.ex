defmodule ElixirProgrammingA3 do
  # Start function
  def start do
    IO.puts("Enter a number or enter 0 to quit:")

    case IO.gets("") |> String.trim() |> Integer.parse() do
      {0, _} -> 
        IO.puts("That's it, thank you!")

      {num, _} when is_integer(num) -> 
        process_input(num)
        start()

      :error -> 
        IO.puts("Your input is not an integer")
        start()
    end
  end

  # Function to handle input
  defp process_input(num) when num < 0 do
    power_result = :math.pow(abs(num), 7)
    int_power_result = trunc(power_result)
    IO.puts("Absolute value raised to the 7th power: #{int_power_result}")
  end

  defp process_input(0) do
    IO.puts("0")
  end

  defp process_input(num) when num > 0 do
    if rem(num, 7) == 0 do
      fifth_root = :math.pow(num, 1 / 5)
      IO.puts("5th root: #{fifth_root}")
    else
      fact_result = factorial(num)
      IO.puts("Factorial: #{fact_result}")
    end
  end

  # Factorial function
  defp factorial(0), do: 1
  defp factorial(n), do: n * factorial(n - 1)
end
