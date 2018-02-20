defmodule Businex do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        worker(Businex.Calendar, [])
      ],
      strategy: :one_for_one,
      name: Businex.Supervisor
    )
  end
end
