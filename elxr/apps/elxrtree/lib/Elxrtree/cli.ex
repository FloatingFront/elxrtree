defmodule Elxrtree.CLI do
  @moduledoc """
  Documentation for Elxrtree.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elxrtree.hello()
      :world

  """
  def hello do
    :world
  end

  def do_fareport(fajsonstructure)  do
     level = 0
     preamble = "*"
     count = 0

     IO.puts "fajsonstructure:"
     IO.inspect fajsonstructure

     decodedfajsonstructure = Poison.decode(fajsonstructure)
#     IO.puts "decodedfajsonstructure:"
#      |> IO.inspect decodedfajsonstructure
      |> IO.inspect
      |> handle_struct

#     fareport(preamble, jsonbit, jsonbits, level, count)

  end

  def handle_struct({:ok, content }) do
     IO.puts "handle_treestuct 1"
     [treestruct | summary ] = content
     [summarystruct | rest]  = summary
     IO.inspect summarystruct
     IO.inspect treestruct
     
     handle_treestruct(treestruct) 
  end

  def handle_struct({_,_}) do
#    IO.inspect
    IO.puts "Something went wrong:handle_struct 2"
  end

  def handle_treestruct(treestruct) do

     IO.puts "handle_treestruct"
     IO.puts "treestruct"
     IO.inspect treestruct
     IO.puts "name"
     IO.inspect treestruct["name"]
     IO.puts "type"
     IO.inspect treestruct["type"]
     IO.puts "contents"
     IO.inspect treestruct["contents"]
     IO.puts "treestruct"
     IO.inspect treestruct
     handle_content(treestruct["contents"],0)
  end

  def handle_content(content,index) do
      IO.puts "handle_content"     
      IO.inspect content
      IO.puts "index"
      IO.inspect index
      IO.puts "content_type"
      [first | content_type_rest] = content
      content_type_1 = get_in(first, ["type"] )
      IO.inspect content_type_1
      IO.puts "case content type"
      case content_type_1 do
         "directory"  -> IO.inspect content[:type]
         "file"       -> IO.inspect get_in(first, ["name"])
         _              -> IO.puts "something tripped up"
      end
  end

  def fareport(preamble, jsonbit, jsonbits, level, count) do
    IO.puts jsonbit
    [jsonbit|jsonbits]= jsonbits
    fareport(preamble,jsonbit, jsonbits, level, count)
  end

  def fareport_file() do

  end

  def fareport_directory() do

  end

#  def fachk(arg), do: IO.inspect arg

  def main(args) do

    {opts,_,_} = OptionParser.parse_head(args,switches: [file: :string, group: :string], aliases: [f: :file, g: :group])

    IO.puts "opts:"
    IO.inspect opts

    [opt| opts] = opts

    IO.puts "opt:"
    IO.inspect opt
    IO.puts "opts:"
    IO.inspect opts

    {file, filename} =  opt

    IO.puts "file(1):"
    IO.inspect file
    IO.puts "filename:"
    IO.inspect filename

    {:ok, file} = File.open(filename)

    IO.puts "file(2):"
    IO.inspect file

    IO.puts "filecontent(1):"
    {:ok, filecontent} = File.read(filename)

    IO.puts "filecontent(2):"
    IO.puts filecontent

    do_fareport(filecontent)

#    case flag do
#      {}
#    end
  end 
   
   

end


