defmodule UrlFormatTest do
  use ExUnit.Case
  doctest UrlFormat
  
  @image_proxy Application.get_env(:url_format, :image_proxy, "")
  @static_url Application.get_env(:url_format, :static_url)
  @static_path Application.get_env(:url_format, :static_path)

  setup do
    file = "users/abcdefg812812/cat.png"
    file_path = "#{@static_path}#{file}"
    url_file = "#{@static_url}#{file}"
    {:ok, file_path: file_path, url_file: url_file}
  end

  test "should generate url for image proxy", %{url_file: url_file, file_path: path_image} do
    url = "#{@image_proxy}#{url_file}"
    assert UrlFormat.image_proxy(path_image) == url 
  end

  test "should generate url for image proxy with options from config", %{file_path: path_image, url_file: url_file} do
    url = "#{@image_proxy}290x220,q50/#{url_file}"
    url_options = "290x220,q50"
    assert UrlFormat.image_proxy(path_image, url_options) == url 
  end

  test "format when config is not set", %{file_path: path_image, url_file: url_file} do
    public = UrlFormat.static_url(path_image)
    assert UrlFormat.do_image_proxy(public, "", "") == url_file
  end

  test "should change the static_path for static_url with config", %{file_path: path_image, url_file: url} do
    assert UrlFormat.static_url(path_image) == url 
  end

  test "should change to localhost for static_url if is not set config", %{file_path: path_image} do
    assert UrlFormat.do_static_url(path_image, nil, nil) == "http://localhost/tmp_files/users/abcdefg812812/cat.png"
  end

  test "should generate image_proxy with external url of image" do
    url = "http://fb.com/perfil/121/cat.png"
    assert UrlFormat.external_image_proxy(url) == "#{@image_proxy}#{url}" 
  end

  test "should generate url from a file struct" do
    path = "tmp_files/users/1e26b7de9c13bc43ef9500a4" 
    filename = "/reepsy-538849-943716-1436396935435.jpg" 
    assert UrlFormat.url_image(path, filename, "290x220,q80") == "http://imageproxy.api.com/290x220,q80/http://static.api.com/users/1e26b7de9c13bc43ef9500a4/reepsy-538849-943716-1436396935435.jpg"
  end

end
