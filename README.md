# SinVirt

A simple Sinatra.rb web interface for [libvirt](http://libvirt.org/).  
Note: This is my first real attempt at writing something in ruby.

Currently this will connect to a node and list all _domains_ and their state. (running or not)  
Eventually I hope to grow this into a simple app that can be used as a self serve VM management. (PaaS) 

# Dependencies

####Packages
* ruby 1.8

####GEMS
* sinatra
* libvirt

# Install and Running

    git clone https://aussielunix@github.com/aussielunix/SinVirt.git SinVirt
    cd SinVirt && ./main.rb

# TODO

* learn more ruby
* application auth via rack middleware
* action logging 
* VM provisioning from kickstart
* ability to manage multiple nodes
* caching layer to stop smashing libvirt
* libvirt authentication/authorization

Licence
-------

GPLv3 - See COPYING
