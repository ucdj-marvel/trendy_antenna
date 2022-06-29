require "rails_helper"

describe "Home", type: :system do
  before do
    driven_by(:chrome)
  end

  it "トップページで'MEN RANKING'が表示されること" do
    visit root_path
    expect(current_path).to eq "/"
    expect(page).to have_content("MEN RANKING")
  end

  it "サインアップする" do
    visit root_path
    click_link("Sign-up")
    sleep 5
  end
end