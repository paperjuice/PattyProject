defmodule Backend.Application do
  alias Backend.Model
  alias Backend.WebsocketServer
  alias Backend.WebsocketServer.Handlers.RoomCleaner

  use Application

  def start(_type, _orgs) do
    Model.init()
    WebsocketServer.Init.init()
    RoomCleaner.genserver_init()

    children = [
      { Plug.Adapters.Cowboy2,
        scheme: :http,
        plug: Backend.Plug.Adapter,
        options: [ port: 8999 ]
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
