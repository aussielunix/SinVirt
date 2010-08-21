#!/usr/bin/env ruby

$LOAD_PATH << File.join(Dir.getwd, 'lib')

require 'rubygems'
require "bundler"
Bundler.setup
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-transactions'
require 'libvirt'
# Models etc
require 'sinvirt'

before do
          @vconn = SinVirt::LibVirt.new("glenlivet")
end


# datamapper magick for auto migrations.
DataMapper.auto_upgrade!


get '/' do
    #TODO: auth framework
    erb "Welcome"
end

#VMs management
get '/domains/list' do
  @cdetails = SinVirt::DB::Customer.all()
  @domains = []
  uuids = @vconn.list_all_domains
  uuids.each do |uuid|
    name = @vconn.uuid2name(uuid)
    state = @vconn.uuid2state(uuid)
    @domains << Domain.new(uuid, name, state)
  end
  erb :domains
end

get '/about' do
    erb :about
end

get '/console' do
    erb :console
end

get '/:action/:uuid' do
  case params[:action]
    when "start"
        @vconn.startdomain((params[:uuid]))
    when "shutdown"
        @vconn.stopdomain((params[:uuid]))
    when "destroy"
        @vconn.destroydomain(params[:uuid])
    else
      redirect '/', 500
    end
    redirect '/domains/list'
end


get '/setup' do
    @cdetails = SinVirt::DB::Customer.all()
    erb :setup
end

post '/setup/add' do
   cdetails = SinVirt::DB::Customer.new(params[:cdetails]).save
   redirect '/setup'
end

post '/provisioning/new' do
  newdom = params[:newdom]
  nid = newdom['id']
  ndetails = SinVirt::DB::Customer.get(nid)
  `virt-install --accelerate \
               -n  #{newdom['vname']} \
               -m #{ndetails.mac}  \
               -r #{ndetails.rsize} \
               --vcpus=1 \
               --disk pool=virt,bus=virtio,size=#{ndetails.dsize} \
               --vnc \
               --os-type linux \
               --os-variant=rhel5 \
               --network=network:default \
               --noautoconsole \
               -l http://192.168.122.1/os/centos/5.5/os/x86_64/ \
               -x \"ks=http://192.168.122.1/ks/#{ndetails.kickstart}\"`
    redirect '/domains/list'
end

