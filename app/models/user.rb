# encoding: utf-8

require 'digest/sha1'

class User < ActiveRecord::Base

  # შემოწმებები
  validates_presence_of :name, :first_name, :last_name
  validates_uniqueness_of :name

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

  # ავტორიზაციის მეთოდი
  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  # პაროლის მიღება
  def password
    @password
  end

  # პაროლის დაყენება
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def full_name
    first_name + ' ' + last_name
  end
  
private

  # პაროლის შემოწმება
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  # პაროლის დაკრიპტვა
  def self.encrypted_password(password, salt)
    string_to_hash = password + "dimitri" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  # ავტომატურად ქმნის მარცვალს
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end