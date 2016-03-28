ExUnit.start

Mix.Task.run "ecto.create", ~w(-r BlogEngine.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r BlogEngine.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(BlogEngine.Repo)

