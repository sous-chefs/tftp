require 'spec_helper'

describe port(69) do
  it { should be_listening }
end
