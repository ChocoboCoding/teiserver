defmodule TeiserverWeb.API.RestrictedView do
  use TeiserverWeb, :view

  def render("empty.json") do
    %{}
  end
end
