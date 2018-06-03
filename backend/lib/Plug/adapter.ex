defmodule Backend.Plug.Adapter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "hello")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
