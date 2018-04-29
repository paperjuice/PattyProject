defmodule Backend.Storage.Api do
  alias :mnesia, as: Mnesia


  def get_all(table_name) do
    Mnesia.transaction(fn ->
      Mnesia.match_object({table_name, :_, :_, :_, :_})
    end)
  end

  def get_room_by_id(table_name, id) do
    Mnesia.transaction(fn ->
      Mnesia.match_object({table_name, id, :_, :_, :_})
    end)
  end
end
