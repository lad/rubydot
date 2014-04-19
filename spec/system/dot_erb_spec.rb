# Encoding: UTF-8

require 'rubydot'

describe 'The dot template' do
  it 'creates a dot file' do
    # stupidly simple testing...

    dot_erb = File.read('etc/dot.erb')
    erb = ERB.new(dot_erb)

    M = Struct.new(:name, :classes)
    C = Struct.new(:name, :parent)

    name = 'Gourmet'

    base_app = C.new('BaseApp', nil)
    api = C.new('API', base_app)
    ui = C.new('UI', base_app)
    data_store = C.new('DataStore', nil)

    base_res = C.new('BaseResource', base_app)
    node_res = C.new('NodeResource', base_res)
    job_res = C.new('JobResource', base_res)
    pg_res = C.new('PolicGroupResource', base_res)

    mod1 = M.new('Gourmet', [base_app, api, ui, data_store])
    mod2 = M.new('Gourmet::Resources', [base_res, node_res, job_res, pg_res])
    modules = [mod1, mod2]

    File.write('/tmp/d.dot', erb.result(binding))
  end
end
