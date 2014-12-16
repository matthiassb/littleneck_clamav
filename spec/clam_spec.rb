require "spec_helper"

describe LittleneckClamAV::Clam do

  it_behaves_like "a scanner"

  describe "instance method" do

    describe "command" do

      it "should return clamdscan" do
        subject.command.should == "clamscan"
      end

    end

    describe "scan" do

      it "should call Cocaine" do
        file = __FILE__

        subject.stub(:available?).and_return(true)

        mock_cocaine :cmd => subject.command,
                     :opts => %Q{--no-summary "#{file}"},
                     :params => { :swallow_stderr => true, :expected_outcodes => [0, 1] },
                     :output => "#{file}: OK"

        subject.scan file
      end

    end

  end

end
