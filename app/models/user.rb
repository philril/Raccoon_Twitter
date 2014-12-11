class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :followings
  has_many :tweets

  validates :email, presence: true, uniqueness: true

# Add in user authentication with bCrypt

  include 'bcrypt'

  def password
    @password ||= Password.new(password_hash) if password_hash
    #password_hash must match migration t.string = password_hash
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password)
    self.password == password
  end

end
