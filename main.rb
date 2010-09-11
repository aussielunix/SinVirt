#!/usr/bin/env ruby

$LOAD_PATH << File.join(Dir.getwd, 'lib')

require 'rubygems'
require "bundler"
Bundler.setup
require 'sinatra'
require 'yaml'
require 'dm-core'
require 'dm-migrations'
require 'dm-transactions'
require 'libvirt'
# Models etc
require 'sinvirt'

before do
  CONFIG = YAML.load(File.read("config/config.yml")) unless defined? CONFIG
  @vconn = SinVirt::LibVirt.new(CONFIG['config']['node'])
end


# datamapper magick for auto migrations.
DataMapper.auto_upgrade!


get '/' do
    #TODO: auth framework
    erb "Welcome"
end

#VMs management
get '/domains/list' do
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




