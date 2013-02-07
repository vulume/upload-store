require_relative '../support/spec_helper'
require 'upload_store/aws_policy'

describe UploadStore::AWSPolicy do
  subject { UploadStore::AWSPolicy.allocate }

  before do
    # Since we are configuring class properties we must reset values between
    # each test to ensure consistency. Maybe for future versions we can make
    # a config object which would be singleton.
    UploadStore::AWSPolicy.configure do |config|
      config.access_key_id      = 'AWS_ACCESS_KEY_ID'
      config.secret_access_key  = 'AWS_SECRET_ACCESS_KEY'
      config.bucket             = 'UPLOAD_STORE_S3_BUCKET'
    end
  end

  it 'can be configured' do
    expect{ UploadStore::AWSPolicy.assert_config! }.to_not raise_error
  end

  it 'raise error when configured improperly' do
    UploadStore::AWSPolicy.configure do |config|
      config.access_key_id = nil
    end

    expect{ UploadStore::AWSPolicy.assert_config! }.to raise_error(ArgumentError)
  end

  it 'returns all fields required for an aws s3 form policy' do
    expect(subject.fields.keys).to include(:key, :acl, :policy, :signature, :AWSAccessKeyId)
  end
end
