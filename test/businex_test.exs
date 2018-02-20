defmodule BusinexTest do
  use ExUnit.Case

  describe "Businex.Calendar.business_day?/1" do
    test "a business day is correctly identified" do
      date = parse_date("2018-02-20")
      assert Businex.Calendar.business_day?(date) == true
    end

    test "a holiday is correctly identified" do
      date = parse_date("2018-08-27")
      assert Businex.Calendar.business_day?(date) == false
    end

    test "a non working day is correctly identified" do
      date = parse_date("2018-02-24")
      assert Businex.Calendar.business_day?(date) == false
    end
  end

  describe "Businex.Calendar.subtract_business_days/2" do
    test "that weekends are skipped" do
      date = parse_date("2018-02-20")

      assert Businex.Calendar.subtract_business_days(date, 7) == parse_date("2018-02-09")
    end

    test "that holidays are skipped" do
      date = parse_date("2018-04-03")

      assert Businex.Calendar.subtract_business_days(date, 1) == parse_date("2018-03-29")
    end
  end

  describe "Businex.Calendar.add_business_days/2" do
    test "that weekends are skipped" do
      date = parse_date("2018-02-20")

      assert Businex.Calendar.add_business_days(date, 4) == parse_date("2018-02-26")
    end

    test "that holidays are skipped" do
      date = parse_date("2018-03-30")

      assert Businex.Calendar.add_business_days(date, 1) == parse_date("2018-04-03")
    end
  end

  describe "Businex.Calendar.next_business_day/1" do
    test "that weekends are skipped" do
      date = parse_date("2018-02-23")

      assert Businex.Calendar.next_business_day(date) == parse_date("2018-02-26")
    end

    test "that holidays are skipped" do
      date = parse_date("2018-03-29")

      assert Businex.Calendar.next_business_day(date) == parse_date("2018-04-03")
    end
  end

  describe "Businex.Calendar.previous_business_day/1" do
    test "that weekends are skipped" do
      date = parse_date("2018-04-03")

      assert Businex.Calendar.previous_business_day(date) == parse_date("2018-03-29")
    end

    test "that holidays are skipped" do
      date = parse_date("2018-02-12")

      assert Businex.Calendar.previous_business_day(date) == parse_date("2018-02-09")
    end
  end

  defp parse_date(date), do: Timex.parse!(date, "{YYYY}-{0M}-{D}")
end
