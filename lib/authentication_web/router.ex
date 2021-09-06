defmodule AuthenticationWeb.Router do
  use AuthenticationWeb, :router

  import AuthenticationWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AuthenticationWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    plug AuthenticationWeb.AuthAccessPipeline
  end

  # Private routes
  scope "/", AuthenticationWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/products", ProductController, except: [:index, :show]
  end

  scope "/", AuthenticationWeb do
    pipe_through :browser

    resources "/products", ProductController, only: [:index, :show]

    live "/", PageLive, :index
  end

  scope "/api", AuthenticationWeb.Api, as: :api do
    pipe_through :api

    post "/sign_in", SessionController, :create
    resources "/products", ProductController, only: [:index, :show]
  end

  ## Authentication api routes
  scope "/api", AuthenticationWeb.Api, as: :api do
    pipe_through :api_authenticated

    resources "/products", ProductController, except: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthenticationWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AuthenticationWeb.Telemetry, ecto_repos: [Authentication.Repo]
    end
  end

  ## Authentication routes

  scope "/", AuthenticationWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :put_session_layout]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", AuthenticationWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", AuthenticationWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
