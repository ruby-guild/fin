require_relative '../models'

describe Item do
  subject {Item}
  it '::get_all returns array of hashes' do
    result = subject.get_all "2012.10.06"
    result.should_not be_nil
    result.should be_instance_of(Array)
    result.length.should > 0
    result[0].should be_instance_of(Hash)
  end
end
