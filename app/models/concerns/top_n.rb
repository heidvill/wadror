module TopN
  extend ActiveSupport::Concern
  module ClassMethods

    def top(n)
      sorted_by_rating_in_desc_order = self.all.sort_by { |b| -(b.average_rating) }
      sorted_by_rating_in_desc_order[0..(n-1)]
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

end