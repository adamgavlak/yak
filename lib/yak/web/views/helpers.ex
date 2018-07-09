defmodule Yak.Web.Helpers do
  
  def bend(count, %{one: one, twotofor: twotofor, more: more}) do
    case count do
      1 -> "#{count} #{one}"
      n when n in 2..4 -> "#{count} #{twotofor}"
      _ -> "#{count} #{more}"
    end
  end

  def new_job?(job) do
    case Timex.Interval.new(from: job.inserted_at, until: Timex.now) |> Timex.Interval.duration(:days) < 5 do
      true -> "job--new"
      _ -> ""
    end
  end
end