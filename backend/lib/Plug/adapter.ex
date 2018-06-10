defmodule Backend.Plug.Adapter do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json],
                   pass: ["text/*"],
                   json_decoder: Poison
  plug :match
  plug :dispatch


  get "/" do
    send_resp(conn, 200, "hello")
  end

  post "/register" do
    IO.inspect(conn, label: Hell0)
    send_resp(conn, 200, "hey")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
