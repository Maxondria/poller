defmodule PollerPhxWeb.Router do
  use PollerPhxWeb, :router

  # valid_user: 2, admin_user

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # add the auth module plug to the browser pipeline
    plug PollerPhxWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
    # add plugs here, so we can authenticate the user
    plug :fetch_session
    plug PollerPhxWeb.Plugs.Auth
  end

  scope "/", PollerPhxWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/districts", PollerPhxWeb do
    # [:valid_user, :admin_user] are imported automatically when router above is imported, as seen in poller_phx_web.ex
    pipe_through [:browser, :valid_user, :admin_user]

    # get "/", DistrictController, :index
    # get "/new", DistrictController, :new
    # post "/", DistrictController, :create
    # get "/:id/edit", DistrictController, :edit
    # put "/:id", DistrictController, :update
    # delete "/:id", DistrictController, :delete

    resources "/", DistrictController, except: [:show]
    resources "/:district_id/questions", QuestionController, except: [:show]
    resources "/:district_id/questions/:question_id/choices", ChoiceController, except: [:show]
  end

  scope "/auth", PollerPhxWeb do
    pipe_through :browser

    get "/login", AuthController, :new
    post "/login", AuthController, :create
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api", PollerPhxWeb.Api do
    # unauthenticated routes
    pipe_through :api

    get "/districts", DistrictController, :index
    get "/districts/:district_id", DistrictController, :show
    get "/districts/:district_id/questions", QuestionController, :index
    get "/questions/:question_id/choices", ChoiceController, :index
  end

  scope "/api", PollerPhxWeb.Api do
    # authenticate routes
    pipe_through [:api, :valid_user]

    put "/districts/:district_id/choices/:choice_id", ChoiceController, :vote
  end

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
      live_dashboard "/dashboard", metrics: PollerPhxWeb.Telemetry
    end
  end
end
