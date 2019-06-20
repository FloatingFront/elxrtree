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

  def main(args) do
    {opts,_,_}= OptionParser.parse(args,switches: [file: :string], aliases: [f: :file])
    IO.inspect opts
  end 
   
   

end


