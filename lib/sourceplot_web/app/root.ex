defmodule SourceplotWeb.App do
  use SourceplotWeb, :live_view
  use LiveSvelte.Components

  @impl true
  def render(assigns) do
    ~H"""
    <.Counter number={@number} socket={@socket} />
    """
  end

  @impl true
  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, assign(socket, :number, number)}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :number, 5)}
  end
end
