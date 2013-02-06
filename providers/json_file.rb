action :create do
  unless SensuJsonFile.compare_content(new_resource.path, new_resource.content)
    file new_resource.path do
      mode new_resource.mode
      content SensuJsonFile.dump_json(new_resource.content)
      notifies :create, "ruby_block[sensu_service_trigger]", :immediately
    end
  end
end

action :delete do
  file new_resource.path do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
