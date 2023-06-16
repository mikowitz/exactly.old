defmodule Exactly.Lilypond.File do
  @moduledoc """
  Handles converting a printable Exactly struct into a lilypond source file and output.
  """

  @temp_directory Path.expand("~/.exactly")
  :ok = File.mkdir_p(@temp_directory)

  # Allow us to pass an alternative command in testing to avoid needing to install Lilypond in CI
  @runner Application.compile_env(:exactly, :runner, &:os.cmd/1)

  alias Exactly.Container

  defstruct [:content, :source_path, :output_path]

  def from(%{elements: _} = content) do
    %__MODULE__{content: content}
  end

  def from(content) do
    %__MODULE__{content: Container.new([content])}
  end

  def save(%__MODULE__{content: content} = file, source_path \\ generate_source_path()) do
    source_path = Path.expand(source_path)
    lilypond_contents = build_lilypond_contents(content)
    :ok = File.write(source_path, lilypond_contents)
    %{file | source_path: source_path}
  end

  def compile(%__MODULE__{source_path: source_path} = file) do
    output_path = Path.rootname(source_path)

    [
      Exactly.lilypond_executable(),
      "-s",
      "-o",
      output_path,
      source_path
    ]
    |> Enum.join(" ")
    |> run_command()

    %{file | output_path: output_path <> ".pdf"}
  end

  def show(%__MODULE__{output_path: output_path}) when not is_nil(output_path) do
    run_command("open #{output_path}")
  end

  def run_command(command) do
    command
    |> to_charlist()
    |> then(&@runner.(&1))
  end

  defp build_lilypond_contents(content) do
    [
      """
      \\version "#{Exactly.lilypond_version()}"
      \\language "english"
      """,
      Exactly.to_lilypond(content)
    ]
    |> List.flatten()
    |> Enum.join("\n")
  end

  defp generate_source_path do
    [
      DateTime.utc_now() |> Calendar.strftime("%Y-%m-%d-%H-%M-%S"),
      "-",
      :erlang.system_time(),
      ".ly"
    ]
    |> Enum.join("")
    |> then(&Path.join(@temp_directory, &1))
  end
end
