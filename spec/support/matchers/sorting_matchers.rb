RSpec::Matchers.define :descend_on do |field_name|
  match do |collection|
    !(collection.each_cons(2) do |pair|
      break true if pair[0].send(field_name) < pair[1].send(field_name)  # break out of the loop if not descending (can't use a return because it's a block)
      false
    end)
  end
 
  failure_message_for_should do |collection|
    "expected #{collection} to be in descending order on #{field_name}"
  end
 
  failure_message_for_should_not do |collection|
    "expected #{collection} not to be in descending order on #{field_name}"
  end
end