# vim: tabstop=2:shiftwidth=2:softtabstop=2

include_recipe 'bcpc-hadoop::phoenixqs_kerberos'

site_xml = node.default[:bcpc][:hadoop][:hbase][:site_xml]
generated_values = {}
# For UGI to be able to work properly, we need to specify float host 
# not _HOST, especially since we do not provide keytabs for non floats
generated_values['phoenix.queryserver.kerberos.principal'] =\
  "#{node[:bcpc][:hadoop][:kerberos][:data][:phoenixqs][:principal]}/" +
  float_host(node['fqdn']) +
  "@#{node[:bcpc][:hadoop][:kerberos][:realm]}"
generated_values['phoenix.queryserver.keytab.file'] =\
  "#{node[:bcpc][:hadoop][:kerberos][:keytab][:dir]}/#{node[:bcpc][:hadoop][:kerberos][:data][:phoenixqs][:keytab]}"
generated_values['phoenix.queryserver.serialization'] = 'JSON'

site_xml.merge!(generated_values)

qs_runas = node['bcpc']['hadoop']['phoenix']['phoenixqs']['username']

user qs_runas do
  comment 'Runs phoenix queryserver'
  only_if { node['bcpc']['hadoop']['phoenix']['phoenixqs']['localuser'] }
end

group qs_runas do
  members [ qs_runas ] 
  only_if { node['bcpc']['hadoop']['phoenix']['phoenixqs']['localuser'] }
end

template '/etc/init.d/pqs' do
  source 'etc_initd_pqs.erb'
  variables (qs_runas: qs_runas) 
  mode 0o755
  notifies :restart, 'service[pqs]', :delayed
end

service 'pqs' do
  action [:enable, :start]
end
