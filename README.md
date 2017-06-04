[![Build Status](https://travis-ci.org/svetob/commander.svg?branch=master)](https://travis-ci.org/svetob/commander)

# Commander

__Commander__ is a command line parser which uses OptionParser behind-the-hood
and extends it with:

  - Simple and informative help messages
  - Descriptive error messages
  - Default values for switches
  - Option to specify required switches

## Usage

Add `commander` as a dependency to your `mix.exs` file:

```
defp deps do
  [{:commander, "~> 0.1"}]
end
```

Then run `mix deps.get` to download it.

## Example

`example.exs`:
```Elixir
c = Commander.create("example app", "An example application", "mix run example.exs")
  |> Commander.with_help()
  |> Commander.with_switch(:port, :integer, "HTTP port", required: true, alias: :p)
  |> Commander.with_switch(:data_path, :string, "Data path", default: "data/", alias: :d)

case Commander.parse(c, System.argv()) do
  {:ok, result} ->
      IO.inspect result
  {:help, message} ->
    IO.puts message
  {:error, reason} ->
    IO.puts reason
    IO.puts Commander.help_message(c)
end
```


```
$ mix run example.exs -h
example app - An example application

Arguments:
  --data_path, -d : Data path (Default: "data/")
  --port, -p : (Required) HTTP port
  --help, -h : Print help message

Example: mix run example.exs

$ mix run example.exs --port 8080
[data_path: "data/", port: 8080]

$ mix run example.exs
Missing required options: port
example app - An example application

Arguments:
  --data_path, -d : Data path (Default: "data/")
  --port, -p : (Required) HTTP port
  --help, -h : Print help message

Example: mix run example.exs
```
