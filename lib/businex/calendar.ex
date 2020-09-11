defmodule Businex.Calendar do
  @moduledoc """
  Businex.Calendar provides the main interface
  into the business days functionality.
  """

  use GenServer
  @client_name Businex.Calendar
  alias Businex.Api.Calendar, as: Cal

  ##################
  ### PUBLIC API ###
  ##################

  @doc false
  def start_link do
    calendar = Cal.default_calendar()

    initial_state = %{
      data: Cal.parse_data(calendar)
    }

    GenServer.start_link(__MODULE__, initial_state, name: @client_name)
  end

  @doc """
  Provides a way to set the calendar data. This is
  currently set by default to :bacs by start_link.
  Unless you define and configure custom calendars
  the only calendar available will be `:bacs`.

  ## Examples

      iex> Businex.Calendar.set_calendar(:bacs)
      :ok
  """
  def set_calendar(type) do
    GenServer.cast(@client_name, {:set_calendar, type})
  end

  @doc """
  Check if a given date falls on a business day,
  as defined by the set calendar.

  ## Examples

      iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
      iex> Businex.Calendar.business_day?(date)
      true
  """
  def business_day?(date) do
    GenServer.call(@client_name, {:business_day, date})
  end

  @doc """
  Get the next available business day, as defined
  by the set calendar.

  ## Examples

      iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
      iex> Businex.Calendar.next_business_day(date)
      ~N[2018-02-02 00:00:00]
  """
  def next_business_day(date) do
    GenServer.call(@client_name, {:next_business_day, date})
  end

  @doc """
  Get the previous business day, as defined
  by the set calendar.

  ## Examples

      iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
      iex> Businex.Calendar.previous_business_day(date)
      ~N[2018-01-31 00:00:00]
  """
  def previous_business_day(date) do
    GenServer.call(@client_name, {:previous_business_day, date})
  end

  @doc """
  Adds a given number of business days to
  a given date.

  ## Examples

      iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
      iex> Businex.Calendar.add_business_days(date, 2)
      ~N[2018-02-05 00:00:00]
  """
  def add_business_days(date, delta) do
    GenServer.call(@client_name, {:add_business_days, date, delta})
  end

  @doc """
  Subtracts a given number of business days from
  a given date.

  ## Examples

      iex> date = Timex.parse!("2018-02-01", "{YYYY}-{0M}-{D}")
      iex> Businex.Calendar.subtract_business_days(date, 4)
      ~N[2018-01-26 00:00:00]
  """
  def subtract_business_days(date, delta) do
    GenServer.call(@client_name, {:subtract_business_days, date, delta})
  end

  ###################
  #### CALLBACKS ####
  ###################

  def init(args) do
    {:ok, args}
  end

  def handle_cast({:set_calendar, type}, state) do
    data = Cal.parse_data(type)
    new_state = Map.put(state, :data, data)
    {:noreply, new_state}
  end

  def handle_call({:business_day, date}, _from, state) do
    {:reply, Cal.business_day?(state[:data], date), state}
  end

  def handle_call({:next_business_day, date}, _from, state) do
    {:reply, Cal.next_business_day(state[:data], date), state}
  end

  def handle_call({:previous_business_day, date}, _from, state) do
    {:reply, Cal.previous_business_day(state[:data], date), state}
  end

  def handle_call({:add_business_days, date, delta}, _from, state) do
    {:reply, Cal.add_business_days(state[:data], date, delta), state}
  end

  def handle_call({:subtract_business_days, date, delta}, _from, state) do
    {:reply, Cal.subtract_business_days(state[:data], date, delta), state}
  end
end
