RSpec::Matchers.define :descend_on do |field_name|
  match do |collection|

    description { "#{field_name} collection be in descending order" }

    !(collection.each_cons(2) do |pair|
      failure_message_for_should { "element '#{pair[0].send(field_name)}' is greater than element '#{pair[1].send(field_name)}'" }
      break false if pair[0].send(field_name) < pair[1].send(field_name)  # break out of the loop if not descending (can't use a return because it's a block)
    end)
  end

  failure_message_for_should do |collection|
    "expected #{collection} to be in descending order on #{field_name}"
  end

  failure_message_for_should_not do |collection|
    "expected #{collection} not to be in descending order on #{field_name}"
  end
end

RSpec::Matchers.define :be_accessible do |*attributes|
  match do |response|

    description { "#{attributes.inspect} be accessible" }

    attributes.each do |attribute|
      failure_message_for_should { "#{attribute} should be accessible" }
      failure_message_for_should_not { "#{attribute} should not be accessible" }

      break false unless response.class.accessible_attributes.include?(attribute)
    end
  end
end
