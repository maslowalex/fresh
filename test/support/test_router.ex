defmodule Fresh.TestRouter do
  @moduledoc false

  use Plug.Router

  import Plug.Conn

  plug(:match)
  plug(:dispatch)

  get "/websocket" do
    conn
    |> WebSockAdapter.upgrade(Fresh.WebSocketHandler, [], timeout: :infinity)
    |> halt()
  end

  # Delays the upgrade response so the client stays in the connected-but-not-yet-
  # handshaked state (websocket == nil) long enough for queued frames to accumulate.
  get "/slow_websocket" do
    Process.sleep(100)

    conn
    |> WebSockAdapter.upgrade(Fresh.WebSocketHandler, [], timeout: :infinity)
    |> halt()
  end
end
