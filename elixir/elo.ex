defmodule Elo do
  @development_coefficient 32

  @doc """
  Calculates Elo for 2-32 players.

  ## Examples

      iex> Elo.calculate([{"a", 1, 1600}, {"b", 1, 1600}])
      [{"a", 1, 1600, 0}, {"b", 1, 1600, 0}]

      iex> Elo.calculate([{"a", 1, 1600}, {"b", 1, 1200}])
      [{"a", 1, 1587, -13}, {"b", 1, 1213, 13}]

      iex> Elo.calculate([ {"a", 1, 1600}, {"b", 2, 1600}])
      [{"a", 1, 1616, 16}, {"b", 2, 1584, -16}]

      iex> Elo.calculate([
      ...>   {"a", 1, 1600},
      ...>   {"b", 1, 1600},
      ...>   {"c", 1, 1600}
      ...> ])
      [
        {"a", 1, 1600, 0},
        {"b", 1, 1600, 0},
        {"c", 1, 1600, 0}
      ]

      iex> Elo.calculate([
      ...>   {"a", 1, 1000},
      ...>   {"b", 1, 1100},
      ...>   {"c", 1, 1300}
      ...> ])
      [
        {"a", 1, 1008, 8},
        {"b", 1, 1102, 2},
        {"c", 1, 1290, -10}
      ]

      iex> Elo.calculate([
      ...>   {"a", 1, 1600},
      ...>   {"b", 2, 1600},
      ...>   {"c", 3, 1600}
      ...> ])
      [
        {"a", 1, 1616, 16},
        {"b", 2, 1600, 0},
        {"c", 3, 1584, -16}
      ]

      iex> Elo.calculate([
      ...>   {"a", 1, 1600},
      ...>   {"b", 2, 1400},
      ...>   {"c", 3, 1200}
      ...> ])
      [
        {"a", 1, 1605, 5},
        {"b", 2, 1400, 0},
        {"c", 3, 1195, -5}
      ]
  """
  def calculate(players, k \\ @development_coefficient)

  def calculate([player_1, player_2], k) do
    player_to_map = fn player ->
      [:name, :place, :elo, :delta]
      |> Enum.zip(Tuple.to_list(player))
      |> Enum.into(%{})
    end

    player_1 = player_to_map.(player_1)
    player_2 = player_to_map.(player_2)

    s =
      cond do
        player_1.place < player_2.place -> 1.0
        player_1.place == player_2.place -> 0.5
        true -> 0.0
      end

    ea = 1 / (1.0 + 10.0 ** ((player_2.elo - player_1.elo) / 400.0))
    delta = round(k * (s - ea))

    [
      {player_1.name, player_1.place, player_1.elo + delta, delta},
      {player_2.name, player_2.place, player_2.elo - delta, -delta}
    ]
  end

  def calculate(players, k) when is_list(players) do
    k = k / (length(players) - 1)

    for player_1 <- players,
        player_2 <- players,
        player_1 != player_2 do
      [player_1, player_2]
    end
    |> Enum.map(&Enum.sort(&1))
    |> Enum.uniq()
    |> Enum.reduce(players, fn
      player_tuple, players ->
        [player_1, player_2] = calculate(player_tuple, k)

        players
        |> update_player(player_1)
        |> update_player(player_2)
    end)
  end

  defp update_player(players, {name, _, _, delta}) do
    List.keyreplace(
      players,
      name,
      0,
      case List.keyfind(players, name, 0) do
        {name, place, elo} -> {name, place, elo + delta, delta}
        {name, place, elo, current_delta} -> {name, place, elo + delta, current_delta + delta}
      end
    )
  end
end
