class Patient < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :middle_name, :prefix, :source_mrn, :suffix
end
