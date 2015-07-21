require "rails_helper"

RSpec.describe User, type: :model do
  let(:attr) do
    { name: "Example user", email: "user@example.com", password: "123456", 
    password_confirmation: "123456" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create! attr
  end
  
  it "should require name" do
    no_name_user = User.new attr.merge name: ""
    expect(no_name_user).to be_invalid
  end
  
  it "should reject name that are too long" do
    long_name = "a" * 51
    no_name_user = User.new attr.merge name: long_name
    expect(no_name_user).to be_invalid
  end
  
  it "should require email" do
    no_name_user = User.new attr.merge email: ""
    expect(no_name_user).to be_invalid
  end
  
  it "should accept valid email address" do
    adresses = %w[user@foo.com The_USEr@foo.bar.org first.last@foo.org]
    adresses.each do |address|
      valid_email_user = User.new attr.merge email: address
      expect(valid_email_user).to be_valid
    end
  end
  
  it "should reject invalid email address" do
    adresses = %w[user@foo,com The_USEr_foo.bar.org first.last@foo.]
    adresses.each do |address|
      invalid_email_user = User.new attr.merge email: address
      expect(invalid_email_user).to be_invalid
    end
  end
  
  it "should reject duplicate email address" do
    User.create! attr
    user_with_duplicate_email = User.new attr
    expect(user_with_duplicate_email).to be_invalid
  end
    
  it "should require a password" do
    no_password_user = User.new attr.merge password: '', password_confirmation: ''
    expect(no_password_user).to be_invalid
  end
  
  it "should require a matching password confirmation" do
    invalid_password_user = User.new attr.merge password_confirmation: 'invalid'
    expect(invalid_password_user).to be_invalid
  end
  
  it "should reject short password" do
    short = "a" * 5
    invalid_password_user = User.new attr.merge attr.merge password: short, 
    password_confirmation: short
    expect(invalid_password_user).to be_invalid
  end
  
  it "should reject long password" do
    long = "a" * 41
    invalid_password_user = User.new attr.merge attr.merge password: long, 
    password_confirmation: long
    expect(invalid_password_user).to be_invalid
  end
  
  describe "password encryption" do
    
    let(:user) do
      User.create! attr
    end
    
    it "should have an encrypted password attributes" do
      expect(user).to respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      expect(user.encrypted_password).to_not be_blank
    end
    
    describe "has password method" do
    
      it "should be true if the password match" do
        expect(user.has_password? attr[:password]).to be_truthy
      end
    
      it "should be false if the password does not match" do
        expect(user.has_password? 'invalid').to be false
      end
    end
    
    describe "authenticate method" do
    
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate attr[:email], "wrongpassword"
        expect(wrong_password_user).to be_nil
      end
      
      it "should return nil for an email with no user" do
        nonexistent_user = User.authenticate "nouser@test.org", attr[:password]
        expect(nonexistent_user).to be_nil
      end
      
      it "should return user on email/password match" do
        matching_user = User.authenticate attr[:email], attr[:password]
        expect(matching_user).to eq user
      end
    end
  end

end