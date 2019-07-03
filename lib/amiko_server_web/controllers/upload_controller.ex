defmodule AmikoServerWeb.UploadController do
  use AmikoServerWeb, :controller

  alias AmikoServer.Accounts

  def upload(conn, %{"file" => upload_params}) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)
    s3_url = upload_to_s3(upload_params)

    case Accounts.update_image_url(user, s3_url) do
      {:ok, new_user} ->
        conn
        |> send_resp(200, Poison.encode!(new_user))
      {:error,  %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(changeset.errors))
    end
  end

  defp upload_to_s3(upload_params) do
    file_uuid = UUID.uuid4(:hex)
    image_filename = upload_params.filename
    unique_filename = "#{file_uuid}-#{image_filename}"
    {:ok, image_binary} = File.read(upload_params.path)
    bucket_name = System.get_env("BUCKET_NAME")
    region = System.get_env("AWS_REGION")

    ExAws.S3.put_object(bucket_name, unique_filename, image_binary)
    |> ExAws.request!

    s3_url = "https://s3-#{region}.amazonaws.com/#{bucket_name}/#{bucket_name}/#{unique_filename}"

    s3_url
  end

end
