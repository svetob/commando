defmodule Commander.Help do
  alias Commander.State


  @spec build_help(State.t) :: String.t
  def build_help(state) do
    build_description(state) <> "\n\n" <>
      build_argument_list(state) <> "\n\n" <>
      build_example(state)
  end

  @spec build_invalid_options([{binary(), any()}]) :: String.t
  def build_invalid_options(invalid) do
    invalid = invalid |> Enum.map(fn {sw, _} -> sw end)
    "Unknown options: #{Enum.join(invalid, " ")}"
  end

  defp build_description(state) do
    "#{state.app_name} - #{state.app_description}"
  end

  defp build_argument_list(state) do
    arguments = state.descriptions
    |> Enum.map(fn {switch, desc} ->
      aliases = ["--#{switch}"] ++ aliases_for(state, switch)
      "  #{Enum.join(aliases, ", ")} - #{desc}"
    end)
    |> Enum.join("\n")

    "Arguments:\n#{arguments}"
  end

  defp build_example(state) do
    "Example: #{state.example}"
  end

  defp aliases_for(state, switch) do
    state.aliases
    |> Enum.filter(fn {_, sw} -> sw == switch end)
    |> Enum.map(fn {al, _} -> "-#{al}" end)
  end
end
