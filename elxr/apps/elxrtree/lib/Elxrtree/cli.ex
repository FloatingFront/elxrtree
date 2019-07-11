defmodule Elxrtree.CLI do
  @moduledoc """
  Documentation for Elxrtree.
  """

  alias Elxrtree.ReportLines
  alias Elxrtree.CssStyle

  @doc """
  Hello world.

  ## Examples

      iex> Elxrtree.hello()
      :world

  """
  def hello do
    :world
  end

#  TODO =  """
#  ds = directory slash  // /
#  dc = directory colour // blue
#  fc = file colour      // black
#  so = sort order       // ascending
#  sc = sort columns     // 1+ - column one, ascending, 3- - column 3 descending
#       1+2-3+ - column 1 ascending, column 2 descending, column 3 ascending
#  ss = sort stable      // true
#   
#  add features for html/css creation
#  """

  def handle_filecontent(json_structure) do
#    log_where(__ENV__)
    Poison.decode(json_structure)
#    |> IO.inspect()
    |> handle_decoded_json_struct
  end

  def handle_decoded_json_struct({:ok, content}) do
#    log_where(__ENV__)
    dir_level=0
    IO.puts "#{CssStyle.apply_css_style()}"
    IO.puts "#{CssStyle.apply_div_begin()}"
    handle_struct(content, dir_level)
    IO.puts "#{CssStyle.apply_div_end()}"
  end

  def handle_struct([struct_head | struct_rest], dir_level)  do
#    log_where(__ENV__, "list-head")
    handle_struct(struct_head, dir_level)
    handle_struct(struct_rest, dir_level)
  end

  def handle_struct([] = content, dir_level) do
#    log_where(__ENV__, "list-empty")
    dir_level = dir_level - 1
    IO.puts "#{CssStyle.apply_unordered_list_end}"
    IO.puts "#{CssStyle.apply_list_items_directory_end}"
  end

  def handle_struct(%{"type" => "file", "name" => name} = content, dir_level) do
#    log_where(__ENV__, "map-file")
#    log_file(content, dir_level)
    IO.puts "#{CssStyle.apply_list_item_file(name)}"
    
  end

  def handle_struct(
        %{"type" => "directory", "contents" => dir_contents, "name" => name} = content, dir_level
      ) do
#    log_where(__ENV__, "map-directory")
    dir_level = dir_level + 1
#    log_directory(content, dir_level)
    case dir_level do
      1 ->   IO.puts("#{CssStyle.apply_list_items_root_directory(name)}") 
             IO.puts("#{CssStyle.apply_unordered_list_begin}")

      _ ->   IO.puts("#{CssStyle.apply_list_items_directory_begin(name)}")
             IO.puts("#{CssStyle.apply_unordered_list_begin}")
    end
    handle_struct(dir_contents, dir_level)
  end

  def handle_struct(
        %{"type" => "report", "directories" => directories, "files" => files} = content, dir_level
      ) do
#    log_where(__ENV__, "map-report")
#    IO.puts("dir-level         : #{dir_level}")
    IO.puts("Directories       : #{directories}")
    IO.puts("Files             : #{files}\n")
  end

  def handle_struct(%{} = content, dir_level) do
    log_where(__ENV__, "map-empty")
  end

  def handle_decoded_json_struct({_, _}) do
    log_where(__ENV__)
    IO.puts("Something went wrong:handle_decoded_json_struct 2")
  end

  def log_where(%{function: {function_name, function_arity}}) do
    IO.puts("==== #{function_name} ==== #{function_arity} ====")
  end

  def log_where(%{function: {function_name, function_arity}}, type) do
    IO.puts("==== #{function_name} ==== #{function_arity} ==== #{type}")
  end

  def log_file(%{"type" => "file", "name" => name} = content, dir_level) do
    IO.puts("dir-level         : #{dir_level}")
    IO.puts("name              : #{name}")
    IO.puts("type              : file")
    IO.puts("content-file      : #{inspect(content)}\n")
  end

  def log_directory(%{"type" => "directory", "contents" => dir_contents, "name" => name} = content, dir_level) do
    IO.puts("dir-level         : #{dir_level}")
    IO.puts("name              : #{name}")
    IO.puts("type              : directory")
    IO.puts("content           : #{inspect(dir_contents)}\n")
  end

  def handle_content(nil, [], count) do
    log_where(__ENV__)
    IO.puts(":handle_content  : nil")
  end

#  def handle_file(content_first, content_rest, level, count) do
##    log_where(__ENV__)
##    IO.puts(":handle_file      : #{inspect(content_first)}")
##    IO.puts(get_in(content_first, ["name"]))
#    handle_content(content_rest, level, count)
#  end

  def parse_args(args) do
    options =     
      OptionParser.parse(
        args,
        switches: [file: :string, help: :boolean],
        aliases: [f: :file, h: :help]
      )
  end

  def handle_args(options) do
    {parsed, remaining, errors} = options
    case parsed do
     [help: true]     -> :help
     [file: filename] -> {:file, filename}
     [_,_]            -> {}  # valid arguments options should never reach here
    end 
  end

  def process_args(:help) do
     IO.puts """
     elxrtree
     --------
     Utility for generating html from directory content structure in json format.
     usage: elxrtree -h   
     usage: elxrtree -f json-file
     example: elxrtree -f some-directory-structure.json
     """
  end

  def process_args({:file, filename}) do  
     IO.puts "File: #{inspect(filename)}"
     case File.read(filename) do
        {:ok, filecontent} -> handle_filecontent(filecontent)
        {:error, reason}   -> IO.puts("file: [#{filename}]  #{:file.format_error(reason)}")
     end 
  end

  def process_args({}) do
    IO.puts("Something went wrong... please check the argument options")
    process_args(:help)
  end

  @doc """
  elxrtree utility.
  see elxrtree -h for further info (or grep :help)
  """
  def main(args) do
    parse_args(args)
    |> IO.inspect
    |> handle_args
    |> IO.inspect
    |> process_args
  end
end
