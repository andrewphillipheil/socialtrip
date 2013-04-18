class Trip < ActiveRecord::Base
  attr_accessible :user_id, :name, :destination, :start_date, :end_date, :description

  has_many :invitations
  has_many :users, :through => :invitations

  validates_presence_of :name, :destination, :description, :start_date, :end_date

  before_validation :parse_date_values

  before_destroy :delete_associated_invitations

  private

    def parse_date_values
      parse_start_date if start_date.present?
      parse_end_date if end_date.present?
    end

    def parse_start_date
      self.start_date = start_date.to_date.to_s(:mysql_format)
    end

    def parse_end_date
      self.end_date = end_date.to_date.to_s(:mysql_format)
    end

    def delete_associated_invitations
      invitations.destroy_all
    end     
end