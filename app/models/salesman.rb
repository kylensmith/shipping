class Salesman < ActiveRecord::Base
	#secure password using bcrypt gem
	has_secure_password
	#validate password
	validates_confirmation_of :password
	#make sur password and email are not blank
	validates_presence_of :password, on: :create
	validates_presence_of :email, on: :create
	#check if there is already a salesman for that territory
	validates_uniqueness_of :territory
	#check if there is already an email in the Salesmen table
	validates_uniqueness_of :email
	#check for a valid email using the validates_format_of_email gem
	validates :email, :email_format => { :message => 'Are you sure you entered a valid email address?' }
	#run the unique email method to see if it's anywhere in the database
	validate :unique_email
	has_many :work_orders
	has_many :boats, through: :salesman_boats
	has_many :salesman_boats

	#check that this email is not in the database as a port_manager
	#thanks to http://stackoverflow.com/questions/21012826/validating-uniqueness-across-two-tables for help with this
	#will not work for a 'race condition', but this should not be a problem for our app
	def unique_email
  		self.errors.add(:email, 'Is already in the database') if Archive.where(email: self.email).exists?
	end
end
