defmodule Commander do
  alias Commander.State
  alias Commander.Help

  @type parse_result :: [{atom(), any()}]
  @type conf :: {:required, boolean()} | {:aliases, [atom()]} | {:default, any()}
  @type conf_list :: [conf]

  @spec create(String.t, String.t, String.t) :: State.t
  def create(name, description \\ "", example \\ "") do
    %State{app_name: name,
           app_description: description,
           example: example}
  end

  @spec with_help(State.t) :: State.t
  def with_help(commander) do
    commander |> with_switch(:help, :boolean, "Print help message")
  end

  @spec with_switch(State.t, atom(), State.switch_type, String.t, conf_list) :: State.t
  def with_switch(commander, switch, type, description, conf \\ []) do
    commander
    |> State.add_switch(switch, type)
    |> State.add_description(switch, description)
    |> add_configurations(switch, conf)
  end

  @spec parse(State.t, [String.t]) :: {:ok, parse_result} | {:error, String.t}
  def parse(commander, args) do
    opts = [strict: commander.switches, aliases: commander.aliases]
    case OptionParser.parse(args, opts) |> missing_switches(commander) do
      {result, [], []} ->
        {:ok, result |> result_add_defaults(commander)}
      {_, [], missing} ->
        {:error, Help.build_missing_options(missing)}
      {_, invalid, _} ->
        {:error, Help.build_invalid_options(invalid)}
    end
  end

  defp missing_switches({result, _args, invalid}, state) do
    missing = state.required |> Enum.filter(fn r ->
      !(Keyword.has_key?(result, r))
    end)
    {result, invalid, missing}
  end

  @spec result_add_defaults(parse_result, State.t) :: parse_result
  defp result_add_defaults(result, commander) do
    defaults = commander.defaults
    defaults |> Enum.reduce(result, fn ({switch, default}, result) ->
      result |> Keyword.put_new(switch, default)
    end)
  end

  @spec add_configurations(State.t, atom(), conf_list) :: State.t
  defp add_configurations(commander, switch, conf) do
    if Keyword.has_key?(conf, :default) do
      commander = commander |> State.add_default(switch, Keyword.get(conf, :default))
    end
    if Keyword.has_key?(conf, :aliases) do
      commander = commander |> State.add_aliases(switch, Keyword.get(conf, :aliases))
    end
    if Keyword.get(conf, :required) == true do
      commander = commander |> State.add_required(switch)
    end
    commander
  end

end
