module ApplicationHelper
  def at_home_page?
    controller_name == "operations" && action_name == "index"
  end

  def at_import_page?
    controller_name == "operations" && action_name == "import"
  end
end
