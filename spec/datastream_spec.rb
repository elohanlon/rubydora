require 'spec_helper'

describe Rubydora::Datastream do
  describe "create" do
    before(:each) do
      @mock_repository = mock(Rubydora::Repository)
      @mock_object = mock(Rubydora::DigitalObject)
      @mock_object.should_receive(:repository).any_number_of_times.and_return(@mock_repository)
      @mock_object.should_receive(:pid).any_number_of_times.and_return 'pid'
      @datastream = Rubydora::Datastream.new @mock_object, 'dsid'
    end

    it "should be new" do
      @mock_repository.should_receive(:datastream).and_raise("")
      @datastream.new?.should == true
    end

    it "should be dirty" do
      @mock_repository.should_receive(:datastream).and_raise("")
      @datastream.dirty?.should == true
    end

    it "should call the appropriate api on save" do
      @mock_repository.should_receive(:datastream).and_raise("")
      @mock_repository.should_receive(:add_datastream).with(hash_including(:pid => 'pid', :dsid => 'dsid', :controlGroup => 'M', :dsState => 'A'))
      @datastream.save
    end

    it "should be able to override defaults" do
      @mock_repository.should_receive(:datastream).and_raise("")
      @mock_repository.should_receive(:add_datastream).with(hash_including(:controlGroup => 'E'))
      @datastream.controlGroup = 'E'
      @datastream.save
    end
  end

  describe "retrieve" do
    before(:each) do
      @mock_repository = mock(Rubydora::Repository)
      @mock_object = mock(Rubydora::DigitalObject)
      @mock_object.should_receive(:repository).any_number_of_times.and_return(@mock_repository)
      @mock_object.should_receive(:pid).any_number_of_times.and_return 'pid'
      @datastream = Rubydora::Datastream.new @mock_object, 'dsid'
      @mock_repository.should_receive(:datastream).any_number_of_times.and_return <<-XML
        <datastreamProfile>
          <dsLocation>some:uri</dsLocation>
          <dsLabel>label</dsLabel>
        </datastreamProfile>
      XML
    end

    it "should not be new" do
      @datastream.new?.should == false
      @datastream.dirty?.should == false
    end

    it "should provide attribute defaults from dsProfile" do
      @datastream.dsLocation.should == 'some:uri'
      @datastream.dsLabel.should == 'label'
    end

    it "should mediate access to datastream contents" do
      @mock_repository.should_receive(:datastream_dissemination).with(hash_including(:pid => 'pid', :dsid => 'dsid')).and_return('asdf') 
      @datastream.content.should == "asdf"
    end


  end

  describe "update" do

    before(:each) do
      @mock_repository = mock(Rubydora::Repository)
      @mock_object = mock(Rubydora::DigitalObject)
      @mock_object.should_receive(:repository).any_number_of_times.and_return(@mock_repository)
      @mock_object.should_receive(:pid).any_number_of_times.and_return 'pid'
      @datastream = Rubydora::Datastream.new @mock_object, 'dsid'
      @mock_repository.should_receive(:datastream).any_number_of_times.and_return <<-XML
        <datastreamProfile>
          <dsLocation>some:uri</dsLocation>
          <dsLabel>label</dsLabel>
        </datastreamProfile>
      XML
    end

    it "should allow profile attributes to be replaced" do
      @datastream.dsLabel = "New Label"
      @datastream.dsLabel.should == "New Label"
    end

    it "should call the appropriate api with any dirty attributes" do
      @mock_repository.should_receive(:modify_datastream).with(hash_including(:dsLabel => "New Label"))
      @datastream.dsLabel = "New Label"
      @datastream.save
    end

  end

end
