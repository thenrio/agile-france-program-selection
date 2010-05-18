# given I have AGILE_FRANCE_ENV=production
ENV['AGILE_FRANCE_ENV'] = 'production'
# when I boot, using require spec_helper
require 'spec_helper'
describe 'boot with spec_helper' do
  it 'should overwrite AGILE_FRANCE_ENV boot variable' do
    ENV['AGILE_FRANCE_ENV'].should == 'test'  
  end
end
