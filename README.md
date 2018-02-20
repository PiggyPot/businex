# Businex

<<<<<<< HEAD
Date calculations based on business calendars. Note, only support for BACS calendar currently.
=======
(WIP) Date calculations based on business calendars.
>>>>>>> d9669bbaccfc3f7f446b8bbaab416587daf81148

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `businex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:businex, "~> 0.1.0"}
  ]
end
```

Ensure `businex` is started before your application:

```elixir
def application do
  [applications: [:businex]]
end
```

## Usage

Here are some examples of how to use `businex`.

```elixir
iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
iex> Businex.Calendar.next_business_day(date)
~N[2018-02-02 00:00:00]
iex> Businex.Calendar.business_day?(date)
true
iex> Businex.Calendar.add_business_days(date, 2)
~N[2018-02-05 00:00:00]
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/businex](https://hexdocs.pm/businex).
