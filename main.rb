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

get '/:action/:vm' do
  case params[:action]
    when "start"
      uuid = @vconn.name2uuid(params[:vm])
      @vconn.startdomain(uuid)
    when "shutdown"
      uuid = @vconn.name2uuid(params[:vm])
      @vconn.stopdomain(uuid)
    when "destroy"
      uuid = @vconn.name2uuid(params[:vm])
      @vconn.destroydomain(uuid)
    else
      redirect '/', 500
    end
    redirect '/'
end



