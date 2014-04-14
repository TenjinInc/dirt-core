shared_examples_for(:returning) do
  it "should return the appropriate messages" do
    actual_msgs = command[:messages]

    if msgs.nil? || msgs.empty?
      actual_msgs.should be_nil
    else
      actual_msgs.should_not be_nil

      msgs.each do |msg|
        actual_msgs.should include msg
      end
    end
  end

  it "should return the appropriate errors" do
    actual_errors = command[:errors]

    if errors.nil?
      actual_errors.should be_nil
    else
      actual_errors.should_not be_nil

      errors.each do |error|
        actual_errors.should include error
      end
    end
  end
end