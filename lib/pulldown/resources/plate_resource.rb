require 'lims-api/resources/plate_resource'

module Lims::Api
  module Resources
    class PlateResource
	    
      def content_to_stream(s, mime_type)
        dimensions_to_stream(s)
        
        s.add_key "pools"
        pools_to_stream(s, mime_type)
        
        s.add_key "wells"
        wells_to_stream(s, mime_type)

        s.add_key "state"
        s.add_value state 

        s.add_key "created_at"
        s.add_value "2012/12/25"

        s.add_key "plate_purpose"
        s.with_hash do
          s.add_key "uuid"
          s.add_value "pulldown_purpose_1"
          s.add_key "name"
          s.add_value "Pulldown purpose name"
          s.add_key "actions"
          s.with_hash do
            s.add_key "read"
            s.add_value "http://localhost:9292/"
          end
          s.add_key "children"
          s.with_hash do
            s.add_key "size"
            s.add_value 1
            s.add_key "actions"
            s.with_hash do
              s.add_key "first"
              s.add_value "http://localhost:9292/plates/page=1"
            end
          end
        end

        s.add_key "source_transfers"
        s.add_value Hash.new

        s.add_key "transfers_to_tubes"
        s.add_value Hash.new
        
        s.add_key "creation_transfer"
        s.add_value Hash.new
      end


      def sequencescape_state_mapper(state)
        case state
        when "in_progress" then "started"
        when "done" then "passed"
        else state
        end
      end

    
      def order_uuid
        "8f590480-1b7d-0130-7e1e-282066132de2"
      end


      def state
        @context.with_session do |s|
          order = s[order_uuid]
          lambda { 
            order.values.each do |item|
              if item.uuid == self.uuid
                return sequencescape_state_mapper(item.status.to_s) 
              end
            end
          }
        end.call
      end


      def pools_to_stream(s, mime_type)
        s.with_hash do
          s.add_key "1d5d1b9e-274d-11e2-93c9-406c8ffffeb6" 
          s.with_hash do
            s.add_key "wells"
            wells_to_stream(s, mime_type)
          end
        end
      end
     
    end
  end
end  
