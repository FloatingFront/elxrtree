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

     IO.puts "decodedfajsonstructure:"
     IO.inspect decodedfajsonstructure


#     [jsonbit|jsonbits]= fajsonstructure

     IO.puts "jsonbit:"
#     IO.inspect jsonbit
     IO.puts "jsonbits:"
#     IO.inspect jsonbits

#     fareport(preamble, jsonbit, jsonbits, level, count)
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


