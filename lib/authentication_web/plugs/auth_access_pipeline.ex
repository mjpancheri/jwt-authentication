defmodule AuthenticationWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :authentication

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
