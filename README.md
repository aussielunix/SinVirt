# SinVirt

A simple Sinatrarb web interface for [libvirt](http://libvirt.org/).  
Note: This is my first real attempt at writing something in ruby.

# Dependencies

####Packages
* ruby 1.8 ( not tested with rub 1.9 yet)
* sqlite3

####GEMS

See Install and Run for easy way to install gem deps

* bundler
* sinatra
* ruby-libvirt
* dm-core (datamapper)
* do_sqlite3

# Install and Run

    git clone https://aussielunix@github.com/aussielunix/SinVirt.git SinVirt
    cd SinVirt
    bundle install ( to install all gem deps. )
    bundle check ( optional )
    rackup config.ru

# Current Features

* add/delete nodes
* display all domains and their status across all nodes
* some basic domain controls - boot/shutdown/destroy

# TODO

* learn more ruby
* application auth - possibly ACLs
* lots of error checking
* action logging - audit trail
* domain provisioning from kickstart
* ability to delete domains
* libvirt authentication/authorization
* possibly move to libvirt-qpid

Licence
-------

GPLv3 - See COPYING
