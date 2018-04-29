defmodule Backend.InitialData do
  require Logger

  @parent %{"hotel_1" => "hotel_1"}
  @status %{"clean" => "clean",
    "dirty" => "dirty",
    "busy" => "busy",
    "in_progress" => "in_progress"}


  def room_list(table_name) when is_atom(table_name) do
    [
      { table_name, 1, 101, @status["clean"], @parent["hotel_1"]},
      { table_name, 2, 102, @status["clean"], @parent["hotel_1"]},
      { table_name, 3, 103, @status["clean"], @parent["hotel_1"]},
      { table_name, 4, 104, @status["clean"], @parent["hotel_1"]},
      { table_name, 5, 105, @status["clean"], @parent["hotel_1"]},
      { table_name, 6, 106, @status["clean"], @parent["hotel_1"]},
      { table_name, 7, 107, @status["clean"], @parent["hotel_1"]},
      { table_name, 8, 108, @status["clean"], @parent["hotel_1"]},
      { table_name, 9, 109, @status["clean"], @parent["hotel_1"]},
      { table_name, 10, 110, @status["clean"], @parent["hotel_1"]},
      { table_name, 11, 111, @status["clean"], @parent["hotel_1"]},
      { table_name, 12, 112, @status["clean"], @parent["hotel_1"]},
      { table_name, 13, 113, @status["clean"], @parent["hotel_1"]},
      { table_name, 14, 114, @status["clean"], @parent["hotel_1"]},
      { table_name, 15, 115, @status["clean"], @parent["hotel_1"]},
    ]
  end

  def data(table_name) do
    Logger.error(table_name <> "is not an attom")
  end

end
