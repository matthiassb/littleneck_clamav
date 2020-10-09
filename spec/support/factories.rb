def result_factory(override = {})
  options = {
    success: true,
    path: 'foo.txt',
    description: 'OK'
  }.merge(override)

  LittleneckClamAV::Result.new options
end

def mock_terrapin(terrapin_options = {})
  MockTerrapin.new(terrapin_options).mock
end

class MockTerrapin
  include RSpec::Mocks::ExampleMethods

  def initialize(options)
    @options = defaults.merge(options)
  end

  def mock
    build_mock
    setup_exit_value
  end

  private

  attr_reader :options

  def defaults
    { output: '', exitvalue: 0 }
  end

  def build_mock
    basic_mock = expect(Terrapin::CommandLine).to(receive(:new))
    basic_mock.with(*terrapin_arguments) if any_argument_options?
    basic_mock.and_return(terrapin_command_double)
    basic_mock.and_raise(options[:raise]) if options.key?(:raise)
  end

  def terrapin_command_double
    double('terrapin command', run: options[:output])
  end

  def terrapin_arguments
    [options[:cmd], options[:opts], options[:params]]
  end

  def any_argument_options?
    options[:cmd] || options[:opts] || options[:params]
  end

  def setup_exit_value
    options[:exitvalue] == 0 ? `true` : `false`
  end
end
