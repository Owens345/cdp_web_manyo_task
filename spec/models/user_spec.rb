require 'rails_helper'

RSpec.describe 'User model function', type: :model do
  describe 'Validation test' do
    context 'If the user name is an empty string' do
      it 'Validation fails' do
        user = User.new(name: '', email: 'test@example.com', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'If the user email address is an empty string' do
      it 'Validation fails' do
        user = User.new(name: 'test', email: '', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'If the user password is an empty string' do
      it 'Validation fails' do
        user = User.new(name: 'test', email: 'test@example.com', password: '')
        expect(user).not_to be_valid
      end
    end

    context 'If the user email address is already in use' do
      it 'Validation fails' do
        User.create!(name: 'test', email: 'test@example.com', password: 'password')
        user = User.new(name: 'test2', email: 'test@example.com', password: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'If the user password is less than 6 characters' do
      it 'Validation fails' do
        user = User.new(name: 'test', email: 'test@example.com', password: 'passw')
        expect(user).not_to be_valid
      end
    end

    context 'If name has a value, email is unused, and password is at least 6 characters' do
      it 'Validation succeeds' do
        user = User.new(name: 'test', email: 'test@example.com', password: 'password')
        expect(user).to be_valid
      end
    end
  end
end
