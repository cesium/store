defmodule StoreWeb.Router do
  use StoreWeb, :router

  import StoreWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StoreWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user

    plug Plug.Static,
      at: "/store",
      from: :store,
      gzip: false,
      only: ~w(css fonts images store js favicon.ico robots.txt)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug StoreWeb.Auth.AllowedRoles, [:admin]
  end

  scope "/", StoreWeb do
    pipe_through [:browser, :require_authenticated_user]
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live_session :user, on_mount: [{StoreWeb.Hooks, :current_user}] do
      live "/orders", OrderLive.Index, :index
      live "/orders/:id", OrderLive.Show, :show
      live "/users/profile", ProfileLive.Index, :index
      live "/cart", CartLive.Index, :index
    end
  end

  scope "/", StoreWeb do
    pipe_through :browser
    live "/", HomeLive.Index, :index

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create

    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create

    live_session :user_product, on_mount: [{StoreWeb.Hooks, :current_user}] do
      live "/products", ProductLive.Index, :index
      live "/products/:id", ProductLive.Show, :show
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", StoreWeb do
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
    scope "/" do
      pipe_through :browser
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() in [:dev, :stg, :test] do
    scope "/dev" do
      pipe_through :browser
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", StoreWeb do
    pipe_through :browser

    scope "/users" do
      delete "/log_out", UserSessionController, :delete
      get "/confirm", UserConfirmationController, :new
      post "/confirm", UserConfirmationController, :create
      get "/confirm/:token", UserConfirmationController, :edit
      post "/confirm/:token", UserConfirmationController, :update
    end
  end

  scope "/", StoreWeb do
    pipe_through [:browser, :redirect_if_authenticated]

    scope "/users" do
      get "/reset_password", UserResetPasswordController, :new
      post "/reset_password", UserResetPasswordController, :create
      get "/reset_password/:token", UserResetPasswordController, :edit
      put "/reset_password/:token", UserResetPasswordController, :update
    end
  end

  scope "/", StoreWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]

    scope "/admin", Backoffice, as: :admin do
      live "/dashboard", DashboardLive.Index, :index

      live "/product/new", ProductLive.New, :new
      live "/product/:id/edit", ProductLive.Edit, :edit

      live "/orders", OrderLive.Index, :index
      live "/orders/:id/edit", OrderLive.Edit, :edit
      live "/orders/:id", OrderLive.Show, :show
      live "/orders/:id/show/edit", OrderLive.Edit, :edit

      live "/users", UserLive.Index, :index
    end
  end
end
