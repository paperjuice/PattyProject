defmodule Backend.WebsocketServer.Init do
  alias Backend.WebsocketServer.Handlers.RoomCleaner

  def init do
    dispatch =
      :cowboy_router.compile([
        {:_, [{"/roomCleaner", RoomCleaner, [] }]}
      ])

    {:ok, _} =
      :cowboy.start_clear(:room_cleaner,
                         [{:port, 9999}],
                         %{env: %{dispatch: dispatch}}
      )
  end
end
