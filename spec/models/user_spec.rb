require "rails_helper"

describe User, type: :model do
  context "ユーザーネームが空の場合" do
    it "作成できること" do
      expect(build(:user, username: "")).to be_valid
    end
  end

  context "メールアドレスが空の場合" do
    it "エラーを返すこと" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  context "メールアドレスが設定されている場合" do
    it "メールアドレスが重複している場合はエラーを返すこと" do
      create(:user)
      user = build(:user)
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end
  end
end
