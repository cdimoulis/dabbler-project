#
# Custom JSON matchers
#

# Matcher to test if a string can be converted into JSON
RSpec::Matchers.define :look_like_json do |expected|
  match do |actual|
    begin
      JSON.parse(actual)
    rescue JSON::ParserError
      false
    end
  end

  failure_message do |actual|
    "\"#{actual.inspect}\" is not parsable by JSON.parse"
  end

  description do
    "Expects to be JSON parsable String"
  end
end