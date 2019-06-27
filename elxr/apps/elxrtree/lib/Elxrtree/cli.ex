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

  def handle_filecontent(json_structure)  do
     level = 0
     preamble = "*"
     count = 0

     IO.puts "json_structure:"
#     IO.inspect json_structure

     decoded_json_structure = Poison.decode(json_structure)
#      |> IO.inspect
      |> handle_decoded_json_struct
  end

  def handle_decoded_json_struct({:ok, content }) do
     log_where(__ENV__)
     IO.puts "Test1"
     %{function: {name,arity}}  = __ENV__ 
     IO.puts "Test2"
     IO.puts "where : #{name}"
     IO.puts "Test3"
#     IO.puts "where3: #{String.replace_suffix(String.replace_prefix(where,"{:",""),"}","")}" 
#     IO.puts "where4: #{String.split(where,["{:",",","}"])}"
#     String.replace_prefix(where,"{","")
#       |> String.replace_suffix() 
#     IO.puts String.splitter(where,["{",",","}"]) 

#     log_where( where )
#     IO.puts ": #{Map.keys(inspect(__ENV__.function))} :"
#     IO.puts ": #{Map.to_list(inspect(__ENV__.function))} :"
     [treestruct | summary ] = content
     [summarystruct | rest]  = summary
#     IO.inspect summarystruct
#     IO.inspect treestruct
     
     handle_treestruct(treestruct) 
  end

  def handle_decoded_json_struct({_,_}) do
    IO.puts "Something went wrong:handle_decoded_json_struct 2"
  end

  def log_where( %{function: {function_name,function_arity}} ) do
    IO.puts "log_where #{function_name} #{function_arity}"
  end   

  def handle_treestruct(treestruct) do
     log_where(__ENV__)
     IO.puts "handle_treestruct"
#     IO.puts "treestruct-1"
#     IO.inspect treestruct
     IO.puts "name"
     IO.inspect treestruct["name"]
     IO.puts "type"
     IO.inspect treestruct["type"]
     IO.puts "contents"
     IO.inspect treestruct["contents"]
#     IO.puts "treestruct-2"
#     IO.inspect treestruct
# TODO : move start of break-up up to here...
     handle_content(treestruct["contents"],0,0)
  end

  def handle_content(nil,[],count) do
      IO.puts ":handle_content  : nil"     
  end
  
  def handle_content(content,level,count) do
     log_where(__ENV__)
      IO.puts ":handle_content  :"     
      count = count + 1
      IO.puts "count: #{count}"
      IO.puts "level: #{inspect(level)}"
      IO.puts ":content          : #{inspect(content)}"
      [content_first | content_rest] = content
      content_type = get_in(content_first, ["type"] )
      IO.puts ":content_type     :  #{inspect(content_type)}"
      IO.puts ":content_first    :  #{inspect(content_first)}"
      IO.puts ":content_rest     :  #{inspect(content_rest)}"
      IO.puts "case content type"
      case content_type do
#         "directory"   -> IO.inspect content[:type]
         "directory"    -> handle_directory(content_first, content_rest, level, count) #  IO.inspect get_in(content_first, ["name"])
#         "file"        -> IO.inspect get_in(content_first, ["name"])
         "file"         -> handle_file(content_first, content_rest, level, count) #  IO.inspect get_in(content_first, ["name"])
         _              -> IO.puts "something tripped up"
      end
  end

  def handle_directory([], content_rest, level, count) do
    IO.puts ":handle_directory : nil" 
    handle_content(content_rest, (level - 1), count)
  end

  def handle_directory(content_first, content_rest, level, count) do
    level = level + 1
    IO.puts ":handle_directory : #{inspect(content_first)}" 
    IO.puts ":name             : #{get_in(content_first, ["name"])}"
     
    handle_content(content_first, (level), count)
    handle_content(content_rest, (level), count)
  end

  def handle_file([], content_rest, level, count) do
    IO.puts ":handle_file      : nil" 
    handle_content(content_rest, (level), count)
  end


  def handle_file(content_first, content_rest, level, count) do
    IO.puts ":handle_file      : #{inspect(content_first)}" 
    IO.puts get_in(content_first, ["name"])
    handle_content(content_rest, (level), count)
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

  @doc """
  Entry point for the elxrtree utility.
  """
  def main(args) do

    {opts,_,_} = OptionParser.parse_head(
                     args,
                     switches: [file: :string, group: :string], 
                     aliases: [f: :file, g: :group]
                    )

    IO.puts "opts: #{inspect(opts)}"

    [opt| opts] = opts

    IO.puts "opt: #{inspect(opt)} "
    IO.puts "opts: #{inspect(opts)}"

    {file, filename} =  opt
    IO.puts "filename: #{inspect(filename)}"

    {:ok, file} = File.open(filename)

    {:ok, filecontent} = File.read(filename)
#    IO.puts "check filecontent:"
#    IO.inspect filecontent


#    IO.puts "filecontent1: #{inspect(filecontent)}"
#    IO.puts "filecontent2: #{IO.inspect(filecontent)}"
#    IO.puts "filecontent3: #{IO.puts(filecontent)}"

    IO.puts "filecontent: #{filecontent}"


    handle_filecontent(filecontent)
  end 

end


