require 'spec_helper'
describe 'hello' do
  context 'with default values for all parameters' do
    it { should contain_class('hello') }
  end
end
