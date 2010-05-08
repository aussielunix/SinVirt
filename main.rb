#!/opt/ruby-enterprise/bin/ruby -w

$LOAD_PATH << File.join(Dir.getwd, 'lib')

require 'rubygems'
require 'sinatra'
require 'libvirt'
require 'domains'
require 'xmlsimple'

before do
          @vconn = SinVirt::LibVirt.new("foundation")
end

get '/' do
  Domain = Struct.new(:uuid, :name, :state)
  @domains = []
  uuids = @vconn.list_all_domains
  uuids.each do |uuid|
    name = @vconn.uuid2name(uuid)
    state = @vconn.uuid2state(uuid)
    @domains << Domain.new(uuid, name, state)
  end
  erb :show
end


