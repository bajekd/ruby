require 'date'
require 'ostruct'

class User
  attr_accessor :email
  # instead of settings added to attr_accessor and always use it as an hash - use open struct

  def initialize(email:)
    @email = email
  end

  def settings=(role:, active:, last_sign_in_at:)
    @settings = OpenStruct.new(role: role, active: active, last_sign_in_at: last_sign_in_at)
  end
  alias set_settings settings=

  attr_reader :settings
end

class AdminUser < User
  def admin?
    @settings.role == :admin
  end
end

user = User.new(email: 'john.doe@example.com')
# user.settings = { role: :user, active: true, last_sign_in_at: Date.today }
user.set_settings(role: :user, active: true, last_sign_in_at: Date.today)

admin = AdminUser.new(email: 'admin@example.com')
# admin.settings = { role: :admin, active: true, last_sign_in_at: Date.today }
admin.set_settings(role: :admin, active: true, last_sign_in_at: Date.today)

@users = [user, admin]

def signed_in_today?
  @users.each do |user|
    puts("#{user.email} signed in today") if user.settings.last_sign_in_at == Date.today
  end
end

signed_in_today?
