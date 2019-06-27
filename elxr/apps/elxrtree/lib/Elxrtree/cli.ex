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
     log_where(__ENV__)
     decoded_json_structure = Poison.decode(json_structure)
      |> handle_decoded_json_struct
  end

  def handle_decoded_json_struct({:ok, content }) do
     log_where(__ENV__)
#     %{function: {name,arity}}  = __ENV__ 
#     IO.puts "where : #{name}"
     [dirstruct | summary ] = content
     [summarystruct | rest]  = summary
     handle_dirstruct(dirstruct) 
  end

  def handle_decoded_json_struct({_,_}) do
     log_where(__ENV__)
     IO.puts "Something went wrong:handle_decoded_json_struct 2"
  end

  def log_where( %{function: {function_name,function_arity}} ) do
    IO.puts "==== #{function_name} ==== #{function_arity} ===="
  end   

  def handle_dirstruct(dirstruct) do
     log_where(__ENV__)
     IO.puts "name    : #{inspect dirstruct["name"]}"
     IO.puts "type    : #{inspect dirstruct["type"]}"
     IO.puts "contents: #{inspect dirstruct["contents"]}"
# TODO : move start of break-up up to here...
     handle_content(dirstruct["contents"],0,0)
  end

  def handle_content(nil,[],count) do
     log_where(__ENV__)
     IO.puts ":handle_content  : nil"     
  end
  
  def handle_content(content,level,count) do
      log_where(__ENV__)
      count = count + 1
      IO.puts "count: #{count}"
      IO.puts "level: #{inspect(level)}"
      IO.puts ":content          : #{inspect(content)}"
      [content_first | content_rest] = content
      content_type = get_in(content_first, ["type"] )
      IO.puts ":content_type     :  #{inspect(content_type)}"
      IO.puts ":content_first    :  #{inspect(content_first)}"
      IO.puts ":content_rest     :  #{inspect(content_rest)}"
      case content_type do
         "directory"    -> handle_directory(content_first, content_rest, level, count) #  IO.inspect get_in(content_first, ["name"])
         "file"         -> handle_file(content_first, content_rest, level, count) #  IO.inspect get_in(content_first, ["name"])
         _              -> IO.puts "something tripped up"
      end
  end

  def handle_directory([], content_rest, level, count) do
     log_where(__ENV__)
     IO.puts ":handle_directory : nil" 
     handle_content(content_rest, (level - 1), count)
  end

  def handle_directory(content_first, content_rest, level, count) do
     log_where(__ENV__)
     level = level + 1
     IO.puts ":handle_directory : #{inspect(content_first)}" 
     IO.puts ": name            : #{get_in(content_first, ["name"])}"
     IO.puts ": type            : #{get_in(content_first, ["type"])}"
     
     handle_content(content_first, (level), count)
     handle_content(content_rest, (level), count)
  end

  def handle_file([], content_rest, level, count) do
     log_where(__ENV__)
     IO.puts ":handle_file      : nil" 
     handle_content(content_rest, (level), count)
  end

  def handle_file(content_first, content_rest, level, count) do
     log_where(__ENV__)
     IO.puts ":handle_file      : #{inspect(content_first)}" 
     IO.puts get_in(content_first, ["name"])
     handle_content(content_rest, (level), count)
  end

  def fareport(preamble, jsonbit, jsonbits, level, count) do
     log_where(__ENV__)
     IO.puts jsonbit
     [jsonbit|jsonbits]= jsonbits
     fareport(preamble,jsonbit, jsonbits, level, count)
  end

  def report_file() do
     log_where(__ENV__)
  end

  def report_directory() do
     log_where(__ENV__)
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
    IO.puts "filecontent: #{filecontent}"
    handle_filecontent(filecontent)
  end 
end


