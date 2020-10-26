defmodule ExCoveralls.Post do
  @moduledoc """
  Handles general-purpose CI integration with coveralls.
  """
  alias ExCoveralls.Poster
  require Logger

  def execute(stats, options) do
    Logger.warn("Post: options:#{inspect(options)}")
    json = generate_json(stats, options)
    if options[:verbose] do
      IO.puts json
    end
    Poster.execute(json, options)
  end

  def generate_json(source_info, options) do
    Jason.encode!(%{
      repo_token: options[:token],
      service_name: options[:service_name],
      service_number: options[:service_number],
      parallel: options[:parallel],
      source_files: source_info,
      git: generate_git_info(options)
    })
  end

  defp generate_git_info(options) do
    %{head: %{
       committer_name: options[:committer],
       message: options[:message],
       id: options[:sha]
      },
      branch: options[:branch]
    }
  end
end
