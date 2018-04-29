defmodule Backend.Application do
  alias Backend.Model
  alias Backend.WebsocketServer
  alias Backend.WebsocketServer.Handlers.RoomCleaner

  use Application

  def start(_type, _orgs) do
    Model.init()
    WebsocketServer.Init.init()
    RoomCleaner.genserver_init()


    {:ok, self()}
  end
end
