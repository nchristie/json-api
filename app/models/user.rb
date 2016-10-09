class User < ApplicationRecord
  before_create :set_access_token

  has_many :orders, inverse_of: :user, dependent: :destroy

  # Attribute validations
  validates_presence_of :name, message: "Please add a name."
  validates_presence_of :email, message: "Please add an email."

  private

  def set_access_token
    self.access_token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(10)
      break token unless User.where(access_token: token).exists?
    end
  end
end
