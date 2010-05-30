#!/usr/bin/env ruby

$LOAD_PATH << File.join(Dir.getwd, 'lib')

require 'rubygems'
require "bundler"
Bundler.setup
require 'sinatra'
require 'dm-core'
require 'libvirt'
require 'sinvirt'

configure :development do
    DataMapper::Logger.new($stdout, :debug)
    # datamapper magick for auto migrations.
    DataMapper.auto_upgrade!
end

get '/' do
    erb "Welcome"
end

#Nodes management
get '/nodes/list' do
    @nodes = SinVirt::DB::Node.all()
    erb :nodes
end

post '/nodes/new' do
    node = SinVirt::DB::Node.new(params[:node]).save
    redirect '/nodes/list'
end

get '/nodes/delete/:id' do
    node = SinVirt::DB::Node.get(params[:id])
    unless node.nil?
     node.destroy
    end
    redirect '/nodes/list'
end

#VMs management
get '/domains/list' do
    @nodes = SinVirt::DB::Node.all()
    @domains = SinVirt::DB::Domain.all()
    erb :domains
end

post '/domains/new' do
    domain = SinVirt::DB::Domain.new(params[:domain]).save
    redirect '/domains/list'
end

get '/about' do
    erb :about
end

get '/console' do
    erb :console
end

get '/:action/:uuid/:node' do
  case params[:action]
    when "start"
        vconn = SinVirt::LibVirt.new(params[:node])
        vconn.startdomain((params[:uuid]))
        `curl -s http://127.0.0.1:4568/update`
    when "shutdown"
        vconn = SinVirt::LibVirt.new(params[:node])
        vconn.stopdomain((params[:uuid]))
        `curl -s http://127.0.0.1:4568/update`
    when "destroy"
        vconn = SinVirt::LibVirt.new(params[:node])
        vconn.destroydomain(params[:uuid])
        `curl -s env["HTTP_HOST"]/update`
    else
      redirect '/', 500
    end
    redirect '/domains/list'
end

#
# Should be called by cron to sync the db with libvirt
get '/update' do
    nodes = SinVirt::DB::Node.all()
    nodes.each do |node|
        # retrieve list of domains on node
        @vconn = SinVirt::LibVirt.new(node.hostname)
        uuids = @vconn.list_all_domains
        uuids.each do |uuid|
            if domain = SinVirt::DB::Domain.first(:uuid => uuid)
               #update existing records
               domain.update(:state => @vconn.uuid2state(uuid))
            else
                domain = SinVirt::DB::Domain.new()
                domain.uuid = uuid
                domain.name = @vconn.uuid2name(uuid)
                domain.state = @vconn.uuid2state(uuid)
                domain.node_id = node.id
                domain.save
            end
        end #uuids.each
    end #nodes.each 
    redirect '/domains/list'
end #route

