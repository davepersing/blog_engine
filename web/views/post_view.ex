defmodule BlogEngine.PostView do
  use BlogEngine.Web, :view

  def markdown(body) do
      body
      |> Earmark.to_html
      |> raw
  end
end
