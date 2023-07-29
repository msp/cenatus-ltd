defmodule Mix.Tasks.Sitemap.Generate do
  use Mix.Task
  alias ExAws.S3

  @shortdoc "SEO Sitemap"

  def run(_args) do
    Mix.shell.info "starting sitemap generation...."

    bucket = "mattspendlove"
    sitemap_dir = System.tmp_dir

    CenatusLtd.Sitemaps.generate
    Mix.shell.info "finished sitemap generation in [#{sitemap_dir}], uploading to S3.."

    case ExAws.S3.list_objects(bucket) |> ExAws.request do
      {:ok, _result} ->
        Mix.shell.info "OK - bucket [#{bucket}] exists"
      {:error, result} ->
        Mix.shell.error "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Mix.shell.error "ERROR - bucket missing: #{result}"
    end

    sitemap_dir
    |> Path.join("**/*.xml")
    |> Path.wildcard()
    |> Enum.map(fn(filepath) ->
      IO.puts "Uploading ------------------> #{filepath}"
      S3.put_object(bucket, Path.basename(filepath), File.read!(filepath))
      |> ExAws.request!
    end)

    Mix.shell.info "DONE sitemap generation"
  end
end
