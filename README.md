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

# TODO

* learn more ruby
* learn some basic javascript
* ability to delete/archive domains
* domain provisioning from kickstart
* application auth - possibly ACLs
* lots of error checking
* action logging - audit trail
* libvirt authentication/authorization
* possibly move to libvirt-qpid
* add a [HTML5 VNC viewer](http://github.com/kanaka/noVNC) to gain console access to domains 

Licence
-------

GPLv3 - See COPYING
