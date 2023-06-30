import Config

config :exactly, :runner, &IO.puts/1

config :mix_test_watch,
  tasks: [
    "test --include lilypond",
    "credo --strict --all"
  ]
