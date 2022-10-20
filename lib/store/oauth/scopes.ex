defmodule Store.Oauth.Scopes do
  @moduledoc false

  import StoreWeb.Gettext

  def scope_gettext(scope) do
    case scope do
      "public" -> gettext("scopepublic")
      "email" -> gettext("scopeemail")
      "password" -> gettext("password")
    end
  end
end
