def sensu_ctl
  "/opt/sensu/bin/sensu-ctl"
end

def sensu_service_pipe
  "/opt/sensu/sv/#{new_resource.service}/supervise/ok"
end

def sensu_service_path
  "/opt/sensu/service/#{new_resource.service}"
end

def sensu_runit_service_enabled?
  ::File.symlink?(sensu_service_path) && ::FileTest.pipe?(sensu_service_pipe)
end

def load_current_resource
  case new_resource.init_style
  when "sysv"
    service new_resource.service do
      provider node.platform_family =~ /debian/ ? Chef::Provider::Service::Init::Debian : Chef::Provider::Service::Init::Redhat
      supports :status => true, :restart => true
      action :nothing
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  when "runit"
    service new_resource.service do
      start_command "#{sensu_ctl} #{new_resource.service} start"
      stop_command "#{sensu_ctl} #{new_resource.service} stop"
      status_command "#{sensu_ctl} #{new_resource.service} status"
      restart_command "#{sensu_ctl} #{new_resource.service} restart"
      supports :restart => true, :status => true
      action :nothing
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  end
end

action :enable do
  case new_resource.init_style
  when "sysv"
    service new_resource.service do
      action :enable
    end
  when "runit"
    ruby_block "block_until_runsv_#{new_resource.service}_available" do
      block do
        Chef::Log.debug("waiting until named pipe #{sensu_service_pipe} exists")
        until ::FileTest.pipe?(sensu_service_pipe)
          sleep(1)
          Chef::Log.debug(".")
        end
      end
      action :nothing
    end

    execute "sensu-ctl_#{new_resource.service}_enable" do
      command "#{sensu_ctl} #{new_resource.service} enable"
      not_if { sensu_runit_service_enabled? }
      notifies :create, "ruby_block[block_until_runsv_#{new_resource.service}_available]", :immediately
    end
  end
end

action :disable do
  case new_resource.init_style
  when "sysv"
    service new_resource.service do
      action :disable
    end
  when "runit"
    execute "sensu-ctl_#{new_resource.service}_disable" do
      command "#{sensu_ctl} #{new_resource.service} disable"
      only_if { sensu_runit_service_enabled? }
    end
  end
end

action :start do
  service new_resource.service do
    action :start
  end
end

action :stop do
  service new_resource.service do
    action :stop
  end
end

action :restart do
  service new_resource.service do
    action :restart
  end
end
