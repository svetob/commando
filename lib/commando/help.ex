defmodule Commando.Help do
  alias Commando.State

  @moduledoc """
  Help message builders.
  """

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

  @spec build_missing_options([atom()]) :: String.t
  def build_missing_options(missing) do
    "Missing required options: #{Enum.join(missing, " ")}"
  end

  defp build_description(state) do
    "#{state.app_name} - #{state.app_description}"
  end

  defp build_argument_list(state) do
    arguments = state.descriptions
    |> Enum.map(fn {switch, desc} ->
      aliases = ["--#{switch}"] ++ aliases_for(state, switch)

      "  #{Enum.join(aliases, ", ")} : #{required(state, switch)}#{desc}#{default(state, switch)}"
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

  defp required(state, switch) do
    if state.required |> Enum.member?(switch) do
      "(Required) "
    else
      ""
    end
  end

  defp default(state, switch) do
    if state.defaults |> Keyword.has_key?(switch) do
      " (Default: #{inspect Keyword.get(state.defaults, switch)})"
    else
      ""
    end
  end
end
