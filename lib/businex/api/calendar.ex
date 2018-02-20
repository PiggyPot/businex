defmodule Businex.Api.Calendar do
  @data_files %{
    bacs: "#{File.cwd!()}/lib/businex/data/bacs.yml"
  }

  def business_day?(calendar, date) do
    cond do
      Enum.member?(calendar["working_days"], day_name(date)) == false ->
        false

      Enum.member?(calendar["holidays"], date) ->
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
    data =
      @data_files[type]
      |> YamlElixir.read_from_file()

    converted_dates = transform_dates(data["holidays"])
    Map.put(data, "holidays", converted_dates)
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
