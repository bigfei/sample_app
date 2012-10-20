require 'spec_helper'

describe "Micropost pages" do

  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

    describe "micropost destruction" do
      before { FactoryGirl.create(:micropost, user: user) }

      describe "as correct user" do
        before { visit root_path }

        it "should delete a micropost" do
          expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end
      end
    end

    describe "delete links do not appear for microposts not created by the current user" do
      let(:another_user) { FactoryGirl.create(:user) }

      before do
        FactoryGirl.create(:micropost, user: user)
        another_post = FactoryGirl.create(:micropost, user: another_user, content: "another")
      end

      describe "as correct user" do
        before { visit root_path }

        it "should delete a micropost" do
          expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end
      end

      describe do
        before {
          sign_in another_user
          visit root_path
        }
        it "should render the another_user's feed" do
          another_user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end
      end
    end
  end
end