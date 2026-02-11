defmodule Mix.Tasks.JidoAi.Install.Docs do
  @moduledoc false

  @spec short_doc() :: String.t()
  def short_doc do
    "Install Jido.AI and its dependencies"
  end

  @spec example() :: String.t()
  def example do
    "mix jido_ai.install"
  end

  @spec long_doc() :: String.t()
  def long_doc do
    """
    #{short_doc()}

    This task installs Jido.AI and its dependencies (Jido), adds configuration
    to config/config.exs, and provides setup instructions.

    ## Example

    ```sh
    #{example()}
    ```

    ## What it does

    - Adds {:jido, "~> 2.0"} and {:jido_ai, "~> 2.0"} to mix.exs deps
    - Runs jido's installer to set up jido configuration
    - Adds jido_ai configuration template to config/config.exs

    ## After Installation

    1. Update config/config.exs with your LLM provider settings
       Refer to https://github.com/agentjido/jido_ai for documentation
    """
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.JidoAi.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{
        group: :jido_ai,
        adds_deps: [],
        installs: [
          {:jido, "~> 2.0"}
        ],
        example: __MODULE__.Docs.example(),
        only: nil,
        positional: [],
        composes: [],
        schema: [],
        defaults: [],
        aliases: [],
        required: []
      }
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      igniter
      |> Igniter.Project.Config.configure(
        "config.exs",
        :jido_ai,
        [:models, :provider, :api_key],
        {:code,
         Sourceror.parse_string!("""
           System.get_env("PROVIDER_API_KEY")
         """)}
      )
      |> Igniter.add_notice("""
      Jido.AI has been installed!

      Next steps:
      1. Configure your LLM provider:
        https://github.com/agentjido/jido_ai/blob/main/guides/developer/08_configuration.md
        
      2. Explore documentation: 
        https://github.com/agentjido/jido_ai/blob/main/guides/developer/01_architecture_overview.md
      """)
    end
  end
else
  defmodule Mix.Tasks.JidoAi.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error("""
      The task 'jido_ai.install' requires igniter. Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end
