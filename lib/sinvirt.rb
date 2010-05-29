# Package it all up in a module to avoid namespace issues
#
module SinVirt
    #
    # simple libvirt wrapper
    # not the greatest plesure coding this
    class LibVirt
        # connect to libvirt on the node - requires 'node' param
        #
        def initialize(node)
            @conn = Libvirt::open("qemu+tcp://#{node}/system")
        end
        #
        # retrieve collection of id's for running domains
        def list_run
            @conn.list_domains
        end
        #
        # retrieve collection of names for stopped domains    
        def list_stopped
            @conn.list_defined_domains
        end 
        #
        # Due to libvirt crazyness this is harder than it needs to be.
        # It would be nice to be able to retrieve a list of UUID's for all domains.
        # * retrieve list of id's for running domains
        # * convert to uuid
        # * retrieve list of stopped domains
        # * convert to uuids
        def list_all_domains
            uuids = []
            # list_run & convert to uuids
            rdomainids = self.list_run
            rdomainids.each do |rdomainid|
                uuids << self.id2uuid(rdomainid)
            end
            #    
            # list stopped domains and retrieve their uuids
            sdomains = @conn.list_defined_domains
                sdomains.each do |sdomain|
                uuids << self.name2uuid(sdomain)
            end                
            return uuids
        end
        #
        # lookup a domains uuid by providing it's libvirt name
        # Needed due to libvirt API crazyness - Libvirt::Domain#list_defined_domains only returns names. uuid's would be more usefull
        def name2uuid(name)
            dom = @conn.lookup_domain_by_name(name)
            dom.uuid()
        end
        #
        # needed to lookup a domains name according to libvirt - takes 'uuid' as a required param
        def uuid2name(uuid)
            dom = @conn.lookup_domain_by_uuid(uuid)
            dom.name
        end
        #
        # find out domain's state by uuid. 
        #TODO only 1 or 5 are ever returned with libvirt/kvm
        def uuid2state(uuid)
            dom = @conn.lookup_domain_by_uuid(uuid)
            case dom.info.state
            when 1
                "running"
            when 4
                "shutting down"
            when 5
                "stopped"
            else
                "unknown"
            end
        end
        #
        # lookup a domains uuid by providing it's libvirt id
        # Needed due to libvirt API crazyness - Libvirt::Domain#list_domains only returns domain id's. uuid's would be more usefull
        def id2uuid(id)
            dom = @conn.lookup_domain_by_id(id)
            dom.uuid()
        end
        #
        # shutdown a domain.  - takes 'uuid' as a param    
        # Domain must have ACPId running
        def stopdomain(uuid)
            dom = @conn.lookup_domain_by_uuid(uuid)
            dom.shutdown
        end
        #
        # stop a domain (same as removing power source)
        # This is not a safe shutdown - takes 'uuid' as a required param        
        def destroydomain(uuid)
            dom = @conn.lookup_domain_by_uuid(uuid)
            dom.destroy
        end
        #
        # start a domain - takes 'uuid' as a param
        def startdomain(uuid)
            dom = @conn.lookup_domain_by_uuid(uuid)
            dom.create
        end    
    end #endclass

    # Class holder for all DB related class's
    #
    class DB
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/sinvirt.db") #TODO move to a separate config file
    
        # class/datamapper model for holding 'nodes' - physical machines
        #
        class Node
            include DataMapper::Resource
    
            property  :id,                   Serial
            property  :uuid,                 String
            property  :hostname,             String
            property  :state,                Boolean
    
            has n, :domains
        end # Node class

        # class/datamapper model for holding 'domains' - VM's    
        #
        class Domain
            include DataMapper::Resource
    
            property  :id,                  Serial
            property  :uuid,                String
            property  :name,                String
            property  :state,               String
    
            belongs_to :node
        end # Domain class    
    end # DB class
end # endmodule

