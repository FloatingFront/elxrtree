defmodule Elxrtree.CssStyle do
   def apply_css_style() do
      css_style = """
<style>

.elxrtree, .elxrtree ul, .elxrtree li {
     position: relative;
}

.elxrtree ul {
    list-style: none;
    padding-left: 32px;
}

.elxrtree li::before, .elxrtree li::after {
    content: "";
    position: absolute;
    left: -12px;
}

.elxrtree li::before {
    border-top: 1px solid #000;
    top: 9px;
    width: 8px;
    height: 0;
}

.elxrtree li::after {
    border-left: 1px solid #000;
    height: 100%;
    width: 0px;
    top: 2px;
}

.elxrtree ul > li:last-child::after {
    height: 8px;
}

.elxrtree li {
   color: blue;
}

</style>
"""
  end 

  def apply_list_item_file(item) do
    "<li style=\"color:black\" > #{item} </li>"
  end

  def apply_list_items_root_directory(item) do
    "<li style=\"color:blue;position: relative;
         left: -1px;
         top: 16px;\" > #{item} </li>"
  end

  def apply_list_items_directory_begin(item) do
    "<li> #{item <> "\/"}"
  end

  def apply_list_items_directory_end() do
    "</li>"
  end

  def apply_unordered_list_begin() do
    "<ul>"    
  end

  def apply_unordered_list_end() do
    "</ul>"
  end  

  def apply_div_begin() do
    "<div class=\"elxrtree\">"
  end

  def apply_div_end() do
    "</div>"
  end
end

