class Post < ApplicationRecord
  # Required for a virtual attribute to be passsed, even in a form. Can't
  # be validated on with the built-in Rails methods.
  attribute :all_tags

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # Since virtual attributes don't respond to validations, this checks tag presence
  validate :tags_present?

  validates :user_id, presence: true, format: { with: /[0-9]*/}
  validates :title, presence: true, uniqueness: true, length: { maximum: 80 }
  validates :content, presence: true

  # Sorts the posts by date created
  default_scope { order(created_at: :desc) }

  def tag_post(tag)
    tags << tag
  end

  def untag_post(tag)
    tags.delete(tag)
  end

  def tagged_by?(tag)
    tags.include?(tag)
  end

  def tagging_with?(tag)
    all_tags.split(',').map(&:strip).include?(tag)
  end

  private

  def tags_present?
    errors.add(:base, "Tags must be present") if self.all_tags.blank?
  end
end