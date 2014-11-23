defmodule Datomex do
  def start_link(server, port, alias_db, name) do
    config = %Datomex.Config{ server: server, port: port, alias_db: alias_db, name: name } 
    {:ok, _pid} = Agent.start_link(fn -> config end, name: :config)
  end

  def get_config(elem) do
    Agent.get(:config, &Map.get(&1, elem))
  end

  def root, do: "http://#{server}:#{port}/"
  def db_alias, do: alias_db <> "/" <> name
  def db_uri, do: "#{root}data/#{db_alias}/"
  def db_uri_, do: db_uri <> "-/"
  def server, do: get_config(:server)
  def port, do: get_config(:port)
  def alias_db, do: get_config(:alias_db)
  def name, do: get_config(:name)

  def storages do
    HTTPoison.get("#{root}data/")
  end
end