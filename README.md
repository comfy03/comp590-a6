# comp590-a6

# README for Elixir Programming Assignment


## File 1: `elixir_programming_a3.ex`

### Description
This program prompts the user for a number and performs the following operations:
- **Negative numbers**: Calculates the absolute value raised to the 7th power.
- **`0`**: Outputs `0`.
- **Positive numbers**:
  - If divisible by 7: Calculates the 5th root.
  - Otherwise: Calculates the factorial.

## File 2: `elixir_programming_a5.ex`

### Description
This program implements a chain of three server processes:
- **`Serv1`**:
  - Handles arithmetic operations (`add` and `sub`).
  - Forwards unhandled messages to `Serv2`.
- **`Serv2`**:
  - Processes lists (calculates the sum).
  - Forwards unhandled messages to `Serv3`.
- **`Serv3`**:
  - Handles errors and keeps track of unhandled messages.