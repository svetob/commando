defmodule Commander.State do
  alias Commander.State

  @moduledoc """
  Internal Commander state.
  """


  @typep switch :: {atom(), Commander.switch_type}
  @typep switch_alias :: {atom(), atom()}

  @type t :: %__MODULE__{app_name: String.t,
                         app_description: String.t,
                         example: String.t,
                         switches: [switch],
                         defaults: [{atom(), any()}],
                         descriptions: [{atom(), String.t}],
                         aliases: [switch_alias],
                         required: [atom()]}

  defstruct app_name: "",
            app_description: "",
            example: "",
            switches: [],
            defaults: [],
            descriptions: [],
            aliases: [],
            required: []

  @spec add_switch(t, atom(), Commander.switch_type) :: t
  def add_switch(state, switch, type) do
    %State{state | switches: state.switches |> Keyword.put(switch, type)}
  end

  def add_description(state, switch, description) do
    %State{state | descriptions: state.descriptions |> Keyword.put(switch, description)}
  end

  @spec add_default(t, atom(), any()) :: t
  def add_default(state, switch, default) do
    %State{state | defaults: state.defaults |> Keyword.put(switch, default)}
  end

  def add_alias(state, switch, switch_alias) do
    %State{state | aliases: state.aliases |> Keyword.put(switch_alias, switch)}
  end

  def add_required(state, switch) do
    %State{state | required: state.required ++ [switch]}
  end
end
