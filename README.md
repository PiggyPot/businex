# Businex

[![Hex pm](http://img.shields.io/hexpm/v/businex.svg?style=flat)](https://hex.pm/packages/businex) [![Build Status](https://travis-ci.org/PiggyPot/businex.svg?branch=master)](https://travis-ci.org/PiggyPot/businex)

Date calculations based on business calendars. By default the [BACS calendar](https://github.com/PiggyPot/businex/blob/master/lib/businex/data/bacs.ex) is used. This lib takes influence from the Ruby gem [business](https://github.com/gocardless/business).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `businex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:businex, "~> 0.2.0"}
  ]
end
```

You can define your own custom calendar modules and configure businex to use your calendar.

```elixir
config :businex,
  calendars: %{
    custom: MyApp.MyCustomCalendar,
    other: MyApp.OtherCalendar
  },
  default_calendar: :custom
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
iex> Businex.Calendar.set_calendar(:bacs) # :bacs is the default.
:ok
iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
iex> Businex.Calendar.next_business_day(date)
~N[2018-02-02 00:00:00]
  iex> Businex.Calendar.business_day?(date)
true
iex> Businex.Calendar.add_business_days(date, 2)
~N[2018-02-05 00:00:00]
```

## Tests

```elixir
mix test
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/businex](https://hexdocs.pm/businex).
