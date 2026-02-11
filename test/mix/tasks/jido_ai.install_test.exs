defmodule Mix.Tasks.Jido.AI.InstallTest do
  use ExUnit.Case, async: true
  import Igniter.Test

  test "installs jido and adds configuration" do
    phx_test_project()
    |> Igniter.compose_task("jido_ai.install", [])
    |> assert_has_patch(
      "config/config.exs",
      """
      |config :jido_ai, models: [provider: [api_key: System.get_env("PROVIDER_API_KEY")]]
      """
    )
    |> assert_has_notice("""
    Jido.AI has been installed!

    Next steps:
    1. Configure your LLM provider:
      https://github.com/agentjido/jido_ai/blob/main/guides/developer/08_configuration.md
      
    2. Explore documentation: 
      https://github.com/agentjido/jido_ai/blob/main/guides/developer/01_architecture_overview.md
    """)
  end
end
