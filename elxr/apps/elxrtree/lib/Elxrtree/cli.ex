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
#     decoded_json_structure = 
     Poison.decode(json_structure)
      |> IO.inspect 
      |> handle_decoded_json_struct
  end

  def handle_decoded_json_struct({:ok, content }) do
     log_where(__ENV__)

#     %{function: {name,arity}}  = __ENV__ 
#     IO.puts "where : #{name}"

     IO.puts "content          : #{inspect content}\n"
     handle_struct(content)
  end

  def handle_struct([struct_head|struct_rest]) do
     log_where(__ENV__,"list-head")
     IO.puts "struct_head      : #{inspect struct_head}\n"
     IO.puts "struct_rest      : #{inspect struct_rest}\n"
     handle_struct(struct_head)
     handle_struct(struct_rest)
  end

  def handle_struct([] = content) do
    log_where(__ENV__,"list-empty")
    IO.puts "content           : #{inspect content}\n" 
  end

  def handle_struct(%{"type" => "file"} = content) do
    log_where(__ENV__,"map-file")
    IO.puts "content-file      : #{inspect content}\n" 
  end

  def handle_struct(%{"type" => "directory", "contents" => dir_contents ,"name" => name} = content) do
    log_where(__ENV__,"map-directory")
    IO.puts "name              : #{name}"
    IO.puts "type              : directory"
    IO.puts "content           : #{inspect dir_contents}\n" 
    handle_struct(dir_contents) 
  end

  def handle_struct(%{"type" => "report", "directories" => directories ,"files" => files} = content) do
    log_where(__ENV__,"map-report")
    IO.puts "directories       : #{directories}"
    IO.puts "type              : report"
    IO.puts "files             : #{files}\n"
  end

  def handle_struct(%{} = content) do
    log_where(__ENV__,"map-empty")
    IO.puts "content           : #{inspect content}\n" 
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

  def handle_content(nil,[],count) do
     log_where(__ENV__)
     IO.puts ":handle_content  : nil"     
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

