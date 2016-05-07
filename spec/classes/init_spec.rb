require 'spec_helper'
describe 'timemachine' do

  context 'with defaults for all parameters' do
    it { should contain_class('timemachine') }
  end
end
