defmodule Exactly.Lilypond.File do
  @moduledoc """
  Handles converting a printable Exactly struct into a lilypond source file and output.
  """

  @temp_directory Path.expand("~/.exactly")
  :ok = File.mkdir_p(@temp_directory)

  # Allow us to pass an alternative command in testing to avoid needing to install Lilypond in CI
  @runner Application.compile_env(:exactly, :runner, &:os.cmd/1)

  alias Exactly.{Book, Bookpart, Container, Header}
  alias Exactly.Lilypond.Utils, as: LilypondUtils

  defstruct [:content, :source_path, :output_path, header: nil]

  @type t :: %__MODULE__{
          content: any(),
          source_path: String.t() | nil,
          output_path: String.t() | nil,
          header: Header.t() | nil
        }

  def from(%Book{} = book) do
    %__MODULE__{content: book}
  end

  def from(%Bookpart{} = bookpart) do
    %__MODULE__{content: bookpart}
  end

  def from(%{elements: _} = content) do
    %__MODULE__{content: content}
  end

  def from(content_list) when is_list(content_list) do
    wrapped_contents =
      Enum.map(content_list, fn
        %Book{} = book -> book
        %Bookpart{} = bookpart -> bookpart
        %{elements: _} = content -> content
        content -> Container.new([content])
      end)

    %__MODULE__{content: wrapped_contents}
  end

  def from(content) do
    %__MODULE__{content: Container.new([content])}
  end

  def set_header(%__MODULE__{} = file, %Header{} = header) do
    %__MODULE__{file | header: header}
  end

  def save(
        %__MODULE__{content: content, header: header} = file,
        source_path \\ generate_source_path()
      ) do
    source_path = Path.expand(source_path)
    lilypond_contents = build_lilypond_contents(content, header)
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

  defp build_lilypond_contents(content, header) do
    [
      """
      \\version "#{Exactly.lilypond_version()}"
      \\language "english"
      """,
      build_header(header),
      build_content(content)
    ]
    |> LilypondUtils.concat()
  end

  defp build_header(nil), do: nil
  defp build_header(%Header{} = header), do: Exactly.to_lilypond(header) <> "\n"

  defp build_content(content) when is_list(content) do
    Enum.map_join(content, "\n\n", &Exactly.to_lilypond/1)
  end

  defp build_content(content), do: build_content([content])

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
