# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  title              :string(511)      not null
#  type               :string(7)        not null
#  release_date       :date             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#

require 'spec_helper'

describe Product do
  pending "add some examples to (or delete) #{__FILE__}"
end
