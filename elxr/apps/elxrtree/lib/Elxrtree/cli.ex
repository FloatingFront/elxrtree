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

#  def f(arg), do: IO.inspect arg

#  System.argv()
#  |> Enum.inspect(&Elxrtree.CLI.f/1)

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

#    case flag do
#      {}
#    end
  end 
   
   

end


