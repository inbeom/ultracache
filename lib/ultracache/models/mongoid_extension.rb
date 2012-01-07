module Ultracache
  module Models
    module MongoidExtension
      def cached_queue_score
        self.id.to_s[0..6].to_i(16)
      end
    end
  end
end
