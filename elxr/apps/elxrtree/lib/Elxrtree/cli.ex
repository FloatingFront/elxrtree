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
      |> IO.inspect 
      |> handle_decoded_json_struct
  end

  def handle_decoded_json_struct({:ok, content }) do
     log_where(__ENV__)
#     %{function: {name,arity}}  = __ENV__ 
#     IO.puts "where : #{name}"

     [struct|struct_rest] = content

     [dir_struct | summary ] = content

     [summarystruct | rest]  = summary

     IO.puts "content        : #{inspect content}\n"
     IO.puts "struct         : #{inspect struct}\n"
     IO.puts "struct_rest    : #{inspect struct_rest}\n"
     IO.puts "dir_struct     : #{inspect dir_struct}\n"
     IO.puts "summary        : #{inspect summary}\n"
     IO.puts "summarystructs : #{inspect summarystruct}\n"
     IO.puts "rest           : #{inspect rest}\n"
#     handle_dir_struct(dir_struct) 
     handle_struct(content)
  end

  def handle_struct([struct_head|struct_rest]) do
     log_where(__ENV__,"list-head")
     IO.puts "struct_head    : #{inspect struct_head}\n"
     IO.puts "struct_rest    : #{inspect struct_rest}\n"
     handle_struct(struct_head)
     handle_struct(struct_rest)
  end

  def handle_struct([] = content) do
    log_where(__ENV__,"list-empty")
    IO.puts "content         : #{inspect content}\n" 
  end

  def handle_struct(%{"type" => "file"} = content) do
    log_where(__ENV__,"map-file")
    IO.puts "content         : #{inspect content}\n" 
  end

  def handle_struct(%{"type" => "directory", "contents" => dir_contents ,"name" => name} = content) do
    log_where(__ENV__,"map-directory")
    IO.puts "name            : #{name}"
    IO.puts "type            : directory"
    IO.puts "content         : #{inspect dir_contents}\n" 
    handle_struct(dir_contents) 
  end

  def handle_struct(%{"type" => "report", "directories" => directories ,"files" => files} = content) do
    log_where(__ENV__,"map-report")
    IO.puts "directories     : #{directories}"
    IO.puts "type            : report"
    IO.puts "files           : #{files}\n"
  end

  def handle_struct(%{} = content) do
    log_where(__ENV__,"map-empty")
    IO.puts "content         : #{inspect content}\n" 
  end

  def handle_struct( %{type: "file", name: name, content: content }) do
     log_where(__ENV__,"file")
  end

  def handle_struct([struct_head|struct_rest]) do
     log_where(__ENV__,"rest")
  end

  def handle_decoded_json_struct({_,_}) do
     log_where(__ENV__)
     IO.puts "Something went wrong:handle_decoded_json_struct 2"
  end

  def log_where( %{function: {function_name,function_arity}} ) do
    IO.puts "==== #{function_name} ==== #{function_arity} ===="
  end   

  def log_where( %{function: {function_name,function_arity}}, type ) do
    IO.puts "==== #{function_name} ==== #{function_arity} ==== #{type}"
  end   

  def handle_dir_struct(dir_struct) do
     log_where(__ENV__)
     IO.puts "name    : #{inspect dir_struct["name"]}"
     IO.puts "type    : #{inspect dir_struct["type"]}"
     IO.puts "contents: #{inspect dir_struct["contents"]}"
# TODO : move start of break-up up to here...
     handle_content(dir_struct["contents"],0,0)
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

