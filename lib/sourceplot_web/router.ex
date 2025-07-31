defmodule SourceplotWeb.Router do
  use SourceplotWeb, :router

  import SourceplotWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SourceplotWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SourceplotWeb do
    pipe_through :browser

    live "/", App, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sourceplot, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SourceplotWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SourceplotWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SourceplotWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", App.Users.Register, :new
      live "/users/login", App.Users.Login, :new
      live "/users/reset_password", App.Users.ResetPassword, :new
      live "/users/reset_password/:token", App.Users.ResetPassword.Token, :edit
    end

    post "/users/login", Users.SessionController, :create
  end

  scope "/", SourceplotWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SourceplotWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", App.Users.Settings, :edit
      live "/users/settings/confirm_email/:token", App.Users.Settings, :confirm_email
    end
  end

  scope "/", SourceplotWeb do
    pipe_through [:browser]

    delete "/users/log_out", Users.SessionController, :delete

    live_session :current_user,
      on_mount: [{SourceplotWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", App.Users.Confirm.Token, :edit
      live "/users/confirm", App.Users.Confirm, :new
    end
  end
end
