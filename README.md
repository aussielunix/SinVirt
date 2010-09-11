# SinVirt

A simple Ruby/Sinatra web UI for [libvirt](http://libvirt.org).  
This app is aimed at webdev houses to provide devs/ops a simple, self serve development/test environment for each customer.  
Add in a mix of your favourite configuration management (I bootstrap [Puppet](http://www.puppetlabs.com/) from my kickstarts) to have the VM's built identical to a customer's production environment.  

It is early stages yet and this is still considered to be alpha quality code.  
All dev work is currently done with CentOS 5.5.  
This app currently relies heavily on the host's environment being setup in a particular way.  
I am workming towards either extracting this out to a config file or documenting the server environment's requirements.  

Note: This is my first real attempt at writing something in ruby. Feel free to review my code and make suggestions to improve.  

# Dependencies

####Packages
* ruby 1.8 ( not tested with ruby 1.9 yet)
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
* some basic domain controls - boot/shutdown/power off  

![SinVirt ScreenShot](http://www.lunix.com.au/images/SinVirt-screenshot-0.4.jpg)


# TODO

* learn more ruby
* learn some basic javascript
* ability to delete/archive domains
* domain provisioning from kickstart - See [[wiki]]
* application auth - possibly ACLs
* lots of error checking
* action logging - audit trail
* libvirt authentication/authorization
* possibly move to libvirt-qpid
* add a [HTML5 VNC viewer](http://github.com/kanaka/noVNC) to gain console access to domains 

Licence
-------

GPLv3 - See COPYING
