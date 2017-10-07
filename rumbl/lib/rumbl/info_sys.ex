defmodule Rumbl.InfoSys do
  @backends [Rumbl.InfoSys.Wolfram]

  defmodule Result do
    defstruct score: 0, text: nil, url: nil, backend: nil
  end

  # calling compute with a query will
  # cause spawn_query to be called for each backend
  def compute(query, opts \\ []) do
    limit = opts[:limit] || 0
    backends = opts[:backends] || @backends
    backends
    |> Enum.map(&spawn_query(&1, query, limit))
  end

  # spawn query calls the Rumbl.InfoSys.Supervisor with the
  # backend and query together with some bookkeeping and
  # message sending details, which in turn calls
  # this module's start_link function
  defp spawn_query(backend, query, limit) do
    query_ref = make_ref()
    opts = [backend, query, query_ref, self(), limit]
    {:ok, pid} = Supervisor.start_child(Rumbl.InfoSys.Supervisor, opts)
    {pid, query_ref}
  end

  # the start_link function then proxies the processing
  # to the actual backend module
  def start_link(backend, query, query_ref, owner, limit) do
    backend.start_link(query, query_ref, owner, limit)
  end
end
