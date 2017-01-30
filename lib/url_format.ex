defmodule UrlFormat do

  @url_image_proxy Application.get_env(:url_format, :image_proxy, "")
  @static_url Application.get_env(:url_format, :static_url)
  @static_path Application.get_env(:url_format, :static_path)

  def image_proxy(path_image, url_options \\ "")
  def image_proxy(nil, _), do: ""

  def image_proxy(path_image, url_options) do
    public = static_url(path_image)
    do_image_proxy(public, @url_image_proxy, url_options)
  end

  def do_image_proxy(public, image_proxy, options) do
      Path.join([image_proxy, options, public])
  end

  def external_image_proxy(url, options \\ "")
  def external_image_proxy(nil, _options), do: ""
  def external_image_proxy(url, options) do
    Path.join([@url_image_proxy, options, url])
  end

  def static_url(static_file_path) do
    do_static_url(static_file_path, @static_url, @static_path)
  end

  def do_static_url(static_file_path, nil, nil) do
    "http://localhost/#{static_file_path}"
  end

  def do_static_url(static_file_path, static_url, static_path) do
    String.replace(static_file_path, static_path, static_url)
  end

  def url_image(path, image, opts \\ "")
  def url_image(nil, _image, _opts), do: ""
  def url_image(path, image, opts) do
    file = Path.join(path, image)
    image_proxy(file, opts)
      |> URI.encode
  end

end
