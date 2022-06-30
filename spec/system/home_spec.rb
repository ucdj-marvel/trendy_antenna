require "rails_helper"

describe "Home", type: :system do
  let!(:test_user) { create(:user) }

  before do
    driven_by(:chrome)
    visit root_path
  end

  it "トップページで'MEN RANKING'が表示されること" do
    expect(current_path).to eq "/"
    expect(page).to have_content("MEN RANKING")
  end

  it "ユーザー登録できること" do
    click_link("Sign-up")
    fill_in "Username", with: "signup_test"
    fill_in "Email", with: "signup_test@gmail.com"
    fill_in "Password", with: "passpass"
    fill_in "Password confirmation", with: "passpass"
    click_on "Sign up"
    expect(current_path).to eq "/"
    expect(page).to have_content("Logout")
  end

  it "ログインできること" do
    click_button("Login")
    fill_in "Email", with: test_user.email
    fill_in "Password", with: test_user.password
    click_button "Log in"
    expect(current_path).to eq "/"
    expect(page).to have_content("Logout")
  end

  it "ログアウトできること" do
    click_button("Login")
    fill_in "Email", with: test_user.email
    fill_in "Password", with: test_user.password
    click_button "Log in"
    click_button "Logout"
    expect(current_path).to eq "/"
    expect(page).to have_content("Login")
  end
end