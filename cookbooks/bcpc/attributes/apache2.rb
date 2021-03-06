default['bcpc']['bach_web'].tap do |bach_web|
  # bach web configs
  bach_web['document_root'] = '/var/www/bach'
  bach_web['port'] = 80

  # html portal page
  bach_web['html_url'] = ''
  bach_web['html_file'] = 'index.html'

  # json conf page file
  bach_web['json_url'] = 'json'
  bach_web['json_file'] = 'bach_web.json'

  # extra files to be exposed
  bach_web['files_url'] = 'files'
end
