# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation

  has_secure_password

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  #before_save { |user| user.email = email.downcase }
  before_save { self.email.downcase! }
  before_save :create_remember_token
  before_destroy :cannot_destroy_admin_self

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def cannot_destroy_admin_self
      !self.admin?
    end

end
