defmodule TeiserverWeb.API.Protected.TestView do
  use TeiserverWeb, :view

  def render("test.json", %{reporter: reporter, target: target, id: id}) do
    %{
      reporter: reporter,
      target: target,
      id: id
    }
  end
end
