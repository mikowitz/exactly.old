defmodule Exactly.Lilypond.Executable do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      lilypond_executable =
        case System.cmd("which", ["lilypond"]) do
          {_, 1} -> nil
          {lilypond, 0} -> String.trim(lilypond)
        end

      lilypond_version =
        case lilypond_executable do
          nil ->
            nil

          lilypond ->
            {version_output, 0} = System.cmd(lilypond, ["--version"])
            [[version] | _] = Regex.scan(~r/[\d\.]+/, version_output)
            version
        end

      @lilypond_executable lilypond_executable
      @lilypond_version lilypond_version

      def lilypond_version, do: @lilypond_version
      def lilypond_executable, do: @lilypond_executable
    end
  end
end
