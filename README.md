[![Build Status](https://travis-ci.org/svetob/commando.svg?branch=master)](https://travis-ci.org/svetob/commando)

# Commando

__Commando__ is a command line parser which uses OptionParser behind-the-hood
and extends it with:

  - Simple and informative help messages
  - Descriptive error messages
  - Default values for switches
  - Option to specify required switches

## Usage

Add `commando` as a dependency to your `mix.exs` file:

```
defp deps do
  [{:commando, "~> 0.1"}]
end
```

Then run `mix deps.get` to download it.

## Example

`example.exs`:
```Elixir
c = Commando.create("example app", "An example application", "mix run example.exs")
  |> Commando.with_help()
  |> Commando.with_switch(:port, :integer, "HTTP port", required: true, alias: :p)
  |> Commando.with_switch(:data_path, :string, "Data path", default: "data/", alias: :d)

case Commando.parse(c, System.argv()) do
  {:ok, result} ->
      IO.inspect result
  {:help, message} ->
    IO.puts message
  {:error, reason} ->
    IO.puts reason
    IO.puts Commando.help_message(c)
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
