defmodule AmikoServerWeb.UserView do
  use AmikoServerWeb, :view
  alias AmikoServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone: user.phone,
      image_url: user.image_url,
      profession: user.profession,
      company: user.company,
      website: user.website,
      facebook: user.facebook,
      instagram: user.instagram,
      linkedin: user.linkedin,
      twitter: user.twitter,
      password_hash: user.password_hash}
  end
end
