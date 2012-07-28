require File.expand_path("../../../lib/tasks/metrical_workaround", __FILE__)
include MetricalWorkaround

describe "metrical_preparation" do
  describe "substitute" do
    it "should replace one argument" do
      substitute("before_filter :not_current_user, only: :destroy").should ==
       "before_filter :not_current_user, :only => :destroy"
    end
    it "should replace argument with list" do
      substitute("before_filter :guest_user,     only: [:new, :create]").should ==
       "before_filter :guest_user,     :only => [:new, :create]"
    end
    it "should replace in validation" do
      substitute("validates :password_confirmation, presence: true").should ==
       "validates :password_confirmation, :presence => true"
    end
    it "should replace in association" do
      substitute("has_many :microposts, dependent: :destroy").should ==
       "has_many :microposts, :dependent => :destroy"
    end
    it "should not replace the encoding declaration" do
          substitute("# encoding: UTF-8").should ==
           "# encoding: UTF-8"
    end
    it "should also leave comments alone" do
      substitute("# These ... rules are supported but not enabled by default:\n")
      .should == "# These ... rules are supported but not enabled by default:\n"
    end
  end
end