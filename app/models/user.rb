class User < ActiveRecord::Base
  attr_accessible :company_name, :email, :first_name, :last_name, :occupation_id, :password, :password_confirmation  
  acts_as_authentic do |c|
  	c.login_field = :email
  end
  before_save { |user| user.email = email.downcase }
  has_many :submissions
  has_many :draft_submissions, :through=>:submissions, :source=>:user, :conditions =>['submissions.status=?', 'draft']
  has_many :completed_submissions, :through=>:submissions, :source=>:user, :conditions =>['submissions.status=?', 'complete']

  has_many :orders
  has_many :payments
  
  validates :first_name, :last_name, presence: true, length: {maximum: 10}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  

  def fullname
  	# "#{self.last_name} #{self.first_name}"
  	[self.first_name, self.last_name].reject(&:blank?).join(" ")
  end
end
