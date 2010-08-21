# SinVirt

A simple Sinatrarb web interface for [libvirt](http://libvirt.org/).  
This app is aimed at webdev houses to provide devs a simple self serve development/test environment.  
Add in a mix of your favourite configuration management (I bootstrap [Puppet](http://www.puppetlabs.com/) from my kickstarts) to have the VM's built identical to a customer's production environment.  

Note: This is my first real attempt at writing something in ruby.

# Dependencies

####Packages
* ruby 1.8 ( not tested with rub 1.9 yet)
* sqlite3
* bundler

####GEMS

* bundler
* sinatra
* ruby-libvirt
* dm-core (datamapper)
* dm-migrations
* dm-transactions
* do_sqlite3

# Install and Run

    git clone https://aussielunix@github.com/aussielunix/SinVirt.git SinVirt
    cd SinVirt
    bundle install ( to install all gem deps. )
    bundle check ( optional )
    rackup config.ru

# Current Features

* display all domains and their status  
* some basic domain controls - boot/shutdown/destroy
* register a kickstart file to be used for provisioning new domains  
* very basic provisioning of a domain from a pre-registered kickstart file

# TODO

* learn more ruby
* application auth - possibly ACLs
* lots of error checking
* action logging - audit trail
* ability to delete domains
* libvirt authentication/authorization
* possibly move to libvirt-qpid
* refactor provisioning code to make proper use of libvirt/xml
* UX changes - theme etc
* add a [HTML5 VNC viewer](http://github.com/kanaka/noVNC) to gain console access to domains 

Licence
-------

GPLv3 - See COPYING
