# == Schema Information
#
# Table name: buildings
#
#  abbreviation :string
#  address      :string
#  bldrecnbr    :bigint           not null, primary key
#  city         :string
#  country      :string
#  latitude     :float
#  longitude    :float
#  name         :string
#  nick_name    :string
#  state        :string
#  tsv          :tsvector
#  zip          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_buildings_on_tsv  (tsv) USING gin
#
class Building < ApplicationRecord
  include PgSearch::Model
  self.primary_key = 'bldrecnbr'

  has_many :rooms, primary_key: 'bldrecnbr', foreign_key: 'building_bldrecnbr'
  geocoded_by :address # can also be an IP address

  multisearchable(
    against: [:name, :nick_name, :abbreviation, :bldrecnbr],
    update_if: :updated_at_changed?
  )

  pg_search_scope(
    :with_name,
    against: %i(name nick_name abbreviation),
    using: {
      tsearch: {
        dictionary: "english",
        prefix: true,
        any_word: true,

      }
    }
  )


end
