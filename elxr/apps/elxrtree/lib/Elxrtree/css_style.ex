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

    .elxrtree-root li {
       color: red;
       position: relative;
       left: -1px;
       top: 16px;
    }

    .elxrtree-dir {
       color: blue;
    }


    .elxrtree-dir-contents li {
       color: black;
    }

    </style>
    """
  end

  def apply_list_item_file(item) do
    "<li> #{item} </li>"
  end

  def apply_list_items_root_directory(item) do
    "<div class=elxrtree-root>\n<li> #{item} </li>\n</div>\n<div class=\"elxrtree\">\n<div class=\"elxrtree-dir-contents\">\n<ul>"
  end

  def apply_list_items_directory_begin(directory_name) do
    "<li>\n<div class=\"elxrtree-dir\">\n#{directory_name <> "\/"}\n<div class=\"elxrtree-dir-contents\">"
  end

  def apply_list_items_directory_end(dir_name) do
    "</div>\n</div>\n</li><!-- [dir:#{dir_name}]  --> "
  end

  def apply_unordered_list_begin(dir_name) do
    #    "<div class=\"elxrtree-dir\">\n<ul> <!-- [dir:#{dir_name}] --> "    
    "<ul><!-- +ul [dir:#{dir_name}] -->"
  end

  def apply_unordered_list_end(dir_name) do
    #    "</ul>\n</div> <!-- [dir:#{dir_name}] -->"
    "</ul><!-- -ul [dir:#{dir_name}]-->"
  end

  def apply_div_begin(class_name) do
    "<div class=\"#{class_name}\">"
  end

  def apply_div_end() do
    "</ul>\n</div>"
  end

  def apply_div_begin_dir(class_name, dir_name) do
    "<div class=\"#{class_name}\"> <!-- [dir:#{dir_name}] -->"
  end

  def apply_div_end_dir(dir_name) do
    "</ul>\n</div> <!-- [dir:#{dir_name}] -->"
  end

  def apply_div_begin_dir_content(class_name) do
    "<div class=\"#{class_name}\">"
  end

  def apply_div_end_dir_content() do
    "</ul>\n</div>"
  end
end
