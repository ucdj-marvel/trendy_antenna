require "spec_helper"

describe "WEAR" do
  context "メンズコーディネートランキングページへアクセスできている場合" do
    it "指定した要素が全て存在すること" do
      visit "https://wear.jp/men-ranking/"
      expect(page).to have_xpath("//div[@class='image']/a/p[@class='img']/img")
      expect(page).to have_xpath("//*[@id='main_list']/ol/li")
      within(:xpath, "//*[@id='main_list']/ol/li[1]") do
        expect(page).to have_css("p.rank")
        expect(page).to have_css(".image")
        expect(page).to have_css(".image a")
        expect(page).to have_css(".image  p  img")
      end
    end
  end
end