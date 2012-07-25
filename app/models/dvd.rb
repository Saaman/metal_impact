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

class Dvd < Product
end
