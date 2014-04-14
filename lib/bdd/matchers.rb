RSpec::Matchers.define :data_matches do |expected|
  match do |actual|
    match do |actual|
      expected.keys.each do |key|
        unless expected[key] == actual.send(key)
          return false
        end
      end
      true
    end
  end
end