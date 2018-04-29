defmodule Backend.WebsocketServer.Handlers.RoomCleaner do
  use GenServer

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(state) do
    pid = self()
    store_connection(pid)

    {:ok, state}
  end


  def websocket_handle({:text, text}, state) do

    {:reply, {:text, text}, state}
  end

  def websocket_info(text, state) do
    {:reply, {:text, text}, state}
  end


#### GenServer ####

  def genserver_init do
    GenServer.start_link(__MODULE__, {:connections, []}, [name: :connections])
  end

  def init({:connections, []}) do
    {:ok, []}
  end

  def store_connection(connection_pid) do
    GenServer.cast(:connections, {:store, connection_pid})
  end

  def get_connections do
    GenServer.call(:connections, :get)
  end

#### CALLBACKS ####

  def handle_cast({:store, pid}, state) do
    alive_connection_list =
      state
      |> Enum.filter(fn connection ->
        Process.alive?(connection) == true
      end)

    {:noreply, [pid|alive_connection_list]}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
