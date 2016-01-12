class Api::V1::ReviewSerializer < Api::V1::BaseSerializer
  attributes :id, :rating, :comment, :created_at, :updated_at,
    :lifehack_id, :creator_id, :sum_score

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
