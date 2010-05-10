Domain = Struct.new(:uuid, :name, :state)

module SinVirt
  class LibVirt
    def initialize(node)
        @conn = Libvirt::open("qemu+tcp://#{node}/system")
    end

    def list_run
        @conn.list_domains
    end
    
    def list_stopped
        @conn.list_defined_domains
    end 

    def list_all_domains
        uuids = []
        # list_run & convert to uuids
        rdomainids = self.list_run
        rdomainids.each do |rdomainid|
            uuids << self.id2uuid(rdomainid)
        end

        # list_stopped and convert to uuids
        sdomains = @conn.list_defined_domains
            sdomains.each do |sdomain|
            uuids << self.name2uuid(sdomain)
        end                
        return uuids
    end

    def name2uuid(name)
        dom = @conn.lookup_domain_by_name(name)
        dom.uuid()
    end

    def uuid2name(uuid)
        dom = @conn.lookup_domain_by_uuid(uuid)
        dom.name
    end

    def uuid2state(uuid)
        dom = @conn.lookup_domain_by_uuid(uuid)
        dom.info.state
    end

    def id2uuid(id)
        dom = @conn.lookup_domain_by_id(id)
        dom.uuid()
    end

    def stopdomain(uuid)
        dom = @conn.lookup_domain_by_uuid(uuid)
        dom.shutdown
    end
    
    def destroydomain(uuid)
        dom = @conn.lookup_domain_by_uuid(uuid)
        dom.destroy
    end

    def startdomain(uuid)
        dom = @conn.lookup_domain_by_uuid(uuid)
        dom.create
    end
    
  end #endclass
end # endmodule




