defmodule SourceplotWeb.HomeLiveTest do
  use SourceplotWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders home page", %{conn: conn} do
    {:ok, _index_live, html} = live(conn, ~p"/")

    assert html =~ "Peace of mind from prototype to production"
    assert html =~ "Phoenix Framework"
  end
end
