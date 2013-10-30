actions :enable, :disable

attribute :service, :name_attribute => true, :kind_of => String, :required => true, :regex => /^(sensu-server|sensu-client|sensu-api|sensu-dashboard)$/
attribute :init_style, :kind_of => String, :required => true, :regex => /^(sysv|runit)$/

def initialize(*args)
  super
  @action = :enable
end
