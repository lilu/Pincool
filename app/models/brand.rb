# -*- coding: utf-8 -*-
class Brand
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :uri, type: String
  field :logo, type: String
  field :description, type: String
  field :total_evas, type: Array, default: [0, 0, 0]
  field :eva_names, type: Array, default: %w{设计 性能 实惠}

  belongs_to :founder, class_name: 'User', inverse_of: :found_brands
  has_and_belongs_to_many :followers, class_name: 'User'
  has_many :posts, validate: false
  has_and_belongs_to_many :categories

  validates_presence_of :founder
  validates_presence_of :title, message: "品牌名称不能为空"
  validates_length_of :title, within: 1..20, too_long: "名称最多只能输入%{count}个字"
  validates_presence_of :uri, message: "域名不能为空"
  validates_format_of :uri, with: /^[0-9a-z-]+$/, message: "域名仅限小写字母、数字与“-”"
  validates_length_of :uri, within: 3..255, message: '域名长度应在3-255个字符之间'
  validates_uniqueness_of :uri, case_sensitive: false, message: "此域名已被使用"
  validates_presence_of :logo, message: "请上传logo图片"
  validates_format_of :logo, with: /^\/[0-9a-z]+\.[a-z]+$/
  validates_presence_of :description, message: "一句话简介不能为空"
  validates_length_of :description, within: 1..140, too_long: "简介最多只能输入%{count}个字"

  after_create :followed_by_founder

  paginates_per 20

  default_scope desc(:created_at)

  class << self
    def find_by_uri(uri)
      where(uri: uri).first
    end
  end

  def editable_by?(edit_user)
    edit_user.admin? || founder == edit_user 
  end

  def followed_by?(user)
    followers.find(user.id)
  end

  def followed_by_founder
    founder.follow self
  end

  def reviews
    posts.by_type("review")
  end

  def feelings
    posts.by_type("feeling")
  end

  def evas
    rc = reviews.where(evaluated: true).count
    return [0, 0, 0] if rc <= 0 
    total_evas.map {|eva| eva/rc}
  end

  def update_total_evas(evas)
    evas.each_index do |index|
      total_evas[index] += evas[index]
    end
    save
  end

  def to_param
    uri
  end
end
