defmodule Backend.Model do
  alias Backend.InitialData
  alias :mnesia, as: Mnesia

  require Logger

  @table_name Room

  def init do
    Mnesia.create_schema([node()])
    Mnesia.start()
    Mnesia.create_table(@table_name, [attributes: [:id, :number, :status, :parent]])

    populate_db()
  end

  defp populate_db do
    case Mnesia.table_info(@table_name, :size) do
      :undefined -> populate_db()
      0          -> add_rooms_to_db()
      _          -> Logger.info("Db contains the initial state")
    end
  end

  defp add_rooms_to_db do
    room_list = InitialData.room_list(@table_name)
    #TODO: inregistreaza raspunsul in caz ca da eroare
    Enum.each(room_list, fn room ->
      Mnesia.transaction(fn ->
        Mnesia.write(room)
      end)
    end)

    Logger.info("Data added to the db")
  end

end

