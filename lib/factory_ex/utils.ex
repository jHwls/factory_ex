defmodule FactoryEx.Utils do
  @struct_fields [:__meta__]
  @whitelisted_modules [DateTime]

  @doc """
  Changes structs into maps all the way down, excluding
  things like DateTime.
  """
  @spec deep_struct_to_map(any) :: any
  def deep_struct_to_map(%module{} = struct) when module in @whitelisted_modules do
    struct
  end

  def deep_struct_to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> Map.drop(@struct_fields)
    |> deep_struct_to_map()
  end

  def deep_struct_to_map(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {k, deep_struct_to_map(v)} end)
  end

  def deep_struct_to_map(list) when is_list(list) do
    Enum.map(list, &deep_struct_to_map/1)
  end

  def deep_struct_to_map(elem) do
    elem
  end

end
