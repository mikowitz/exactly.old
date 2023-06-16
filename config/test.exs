import Config

config :exactly, :runner, &IO.puts/1

config :mix_test_watch,
  tasks: ["test", "credo --strict --all"]
