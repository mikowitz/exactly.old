import Config

config :mix_test_watch,
  tasks: [
    "test --include lilypond",
    "credo --strict --all"
  ]
