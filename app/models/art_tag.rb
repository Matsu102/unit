class ArtTag < ApplicationRecord

  # Post アソシエーション
  belongs_to :art
  # Tag アソシエーション
  belongs_to :tag

end
