class PaymentType < ActiveRecord::Base
    has_many :order

    def self.names
      all.collect {|payment_type| payment_type.name}
    end

    #Return all payment type records as array
    def self.payment_types_a
      all.select(:id, :name).to_a
    end


end
