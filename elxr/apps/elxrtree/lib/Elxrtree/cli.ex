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
    IO.puts "#{CssStyle.apply_list_items_directory_begin(name)}"
    IO.puts "#{CssStyle.apply_unordered_list_begin}"
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

  def handle_file(content_first, content_rest, level, count) do
#    log_where(__ENV__)
#    IO.puts(":handle_file      : #{inspect(content_first)}")
#    IO.puts(get_in(content_first, ["name"]))
    handle_content(content_rest, level, count)
  end

  @doc """
  Entry point for the elxrtree utility.
  """
  def main(args) do
#    {opts, _, _} =
    {parsed, remaining, errors} =
#      OptionParser.parse_head(
      OptionParser.parse(
        args,
        switches: [file: :string, help: :boolean],
        aliases: [f: :file, h: :help]
      )

#    IO.puts("#{inspect(opts)}")
    IO.puts("parsed: #{inspect(parsed)} - remaining: #{inspect(remaining)} - errors:#{inspect(errors)}" )

#    [opt | opts] = opts
    [opt | opts] = parsed 

#    IO.puts("opt: #{inspect(opt)} ")
#    IO.puts("opts: #{inspect(opts)}")

    {file, filename} = opt
#    IO.puts("filename: #{inspect(filename)}")
    {:ok, file} = File.open(filename)
    {:ok, filecontent} = File.read(filename)
#    IO.puts("filecontent: #{filecontent}")
    handle_filecontent(filecontent)
  end
end
