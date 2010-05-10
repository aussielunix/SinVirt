#!/opt/ruby-enterprise/bin/ruby -w

$LOAD_PATH << File.join(Dir.getwd, 'lib')

require 'rubygems'
require 'sinatra'
require 'libvirt'
require 'domains'

before do
          @vconn = SinVirt::LibVirt.new("foundation")
end

get '/' do
  @domains = []
  uuids = @vconn.list_all_domains
  uuids.each do |uuid|
    name = @vconn.uuid2name(uuid)
    state = @vconn.uuid2state(uuid)
    case state.to_s
      when "1"
        state = "running"
      when "4"
        state = "shutting down"
      when "5"
        state = "stopped"
      else
        state = "unknown"
      end
    @domains << Domain.new(uuid, name, state)
  end
  erb :show
end


