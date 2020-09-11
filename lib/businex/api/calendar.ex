defmodule Businex.Api.Calendar do
  @data_files %{
    bacs: Businex.Data.Bacs
  }

  def business_day?(calendar, date) do
    cond do
      Enum.member?(calendar.working_days, day_name(date)) == false ->
        false

      Enum.member?(calendar.holidays, date) ->
        false

      true ->
        true
    end
  end

  def next_business_day(calendar, date) do
    new_date =
      date
      |> Timex.add(Timex.Duration.from_days(1))

    case business_day?(calendar, new_date) do
      false -> next_business_day(calendar, new_date)
      true -> new_date
    end
  end

  def previous_business_day(calendar, date) do
    new_date =
      date
      |> Timex.subtract(Timex.Duration.from_days(1))

    case business_day?(calendar, new_date) do
      false -> previous_business_day(calendar, new_date)
      true -> new_date
    end
  end

  def add_business_days(calendar, date, delta) do
    case delta do
      x when x < 0 ->
        date

      0 ->
        date

      val ->
        new_date = next_business_day(calendar, date)
        add_business_days(calendar, new_date, val - 1)
    end
  end

  def subtract_business_days(calendar, date, delta) do
    case delta do
      x when x < 0 ->
        date

      0 ->
        date

      val ->
        new_date = previous_business_day(calendar, date)
        subtract_business_days(calendar, new_date, val - 1)
    end
  end

  def parse_data(type) do
    module = calendar_module(type)
    data = module.get()
    converted_dates = transform_dates(data.holidays)
    Map.put(data, :holidays, converted_dates)
  end

  def default_calendar() do
    Application.get_env(:businex, :default_calendar, :bacs)
  end

  defp calendar_module(date) do
    calendars = Application.get_env(:businex, :calendars, @data_files)
    calendars[date]
  end

  defp transform_dates(date_list) do
    date_list
    |> Enum.map(fn holiday ->
      Timex.parse!(holiday, "%B %e, %Y", :strftime)
    end)
  end

  defp day_name(date) do
    date
    |> Timex.weekday()
    |> Timex.day_name()
    |> String.downcase()
  end
end
