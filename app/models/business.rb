class Business < ActiveRecord::Base
 attr_accessible :address, :agency_name, :applicant_name, :application_ref_no,:status,
                 :country_city, :country_name, :country_state, :date_of_birth,
                 :document_required, :fh_code, :landmark, :latitude, :longitude, :application_status,
                 :pincode_id, :slug, :status, :customer_id, :company_name, :pan_number,:emp_code, :department_id





 belongs_to :customer
 belongs_to :pincode
 has_one :business_verification
 has_one :work_servey
 has_many :business_documents
 has_and_belongs_to_many :b_documents
 belongs_to :department
 extend FriendlyId
 friendly_id :applicant_name, use: :slugged

 geocoded_by :full_address
  after_validation :geocode, :if => :address_changed?

 def full_address
  [address, country_city, country_state, country_name].compact.join(', ')
 end

  include Workflow

workflow_column :status

  workflow do

    state :ready_for_verification do
      event :submit, :transitions_to => :submitted
    end

    state :submitted do
      event :progress, :transitions_to => :awaiting_to_get_verified
    end

    state :awaiting_to_get_verified do
      event :accept, :transitions_to => :verified
    end

    state :verified do
      event :re_indicated, :transitions_to => :ready_for_verification
      event :submitted, :transitions_to => :verified_with_changes
    end

  end





end
