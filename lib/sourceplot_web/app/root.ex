defmodule SourceplotWeb.App do
  use SourceplotWeb, :live_view

  @topic "counter_updates"

  @impl true
  def render(assigns) do
    ~H"""
    <.svelte name="Root" props={%{number: @number}} socket={@socket} />
    """
  end

  @impl true
  def handle_event("set_number", %{"number" => number}, socket) do
    Phoenix.PubSub.broadcast(
      Sourceplot.PubSub,
      @topic,
      {:counter_updated, number}
    )

    {:noreply, assign(socket, :number, number)}
  end

  @impl true
  def handle_info({:counter_updated, number}, socket) do
    {:noreply, assign(socket, :number, number)}
  end

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sourceplot.PubSub, @topic)

    {:ok, assign(socket, :number, 5)}
  end
end
