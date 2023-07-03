defmodule Exactly.Lilypond.File do
  @moduledoc """
  Handles converting a printable Exactly struct into a lilypond source file and output.
  """

  @temp_directory Path.expand("~/.exactly")
  :ok = File.mkdir_p(@temp_directory)

  alias Exactly.{Book, Bookpart, Container, Header}
  alias Exactly.Lilypond.Utils, as: LilypondUtils

  defstruct [:content, :source_file, :output_files, header: nil]

  @type t :: %__MODULE__{
          content: any(),
          source_file: String.t() | nil,
          output_files: [String.t()] | nil,
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
        source_file \\ generate_source_file()
      ) do
    source_file = Path.expand(source_file)
    lilypond_contents = build_lilypond_contents(content, header)
    :ok = File.write(source_file, lilypond_contents)
    %{file | source_file: source_file}
  end

  def compile(%__MODULE__{source_file: source_file} = file) do
    output_path = Path.rootname(source_file)

    {output, 0} =
      [
        Exactly.lilypond_executable(),
        "-o",
        output_path,
        source_file
      ]
      |> run_command()

    output_files =
      Regex.scan(~r/Converting to `(.*)'/, output)
      |> Enum.map(fn [_, filename] -> Path.absname(filename, Path.dirname(output_path)) end)

    %{file | output_files: output_files}
  end

  def show(%__MODULE__{output_files: output_files}) when not is_nil(output_files) do
    run_command(["open" | output_files])
  end

  def run_command([command | args]) do
    System.cmd(command, args, stderr_to_stdout: true)
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

  defp generate_source_file do
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
