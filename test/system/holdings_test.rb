require "application_system_test_case"

class HoldingsTest < ApplicationSystemTestCase
  setup do
    @holding = holdings(:one)
  end

  test "visiting the index" do
    visit holdings_url
    assert_selector "h1", text: "Holdings"
  end

  test "creating a Holding" do
    visit holdings_url
    click_on "New Holding"

    fill_in "Shares", with: @holding.shares
    fill_in "Stock Symbol", with: @holding.stock_symbol
    fill_in "User", with: @holding.user_id
    click_on "Create Holding"

    assert_text "Holding was successfully created"
    click_on "Back"
  end

  test "updating a Holding" do
    visit holdings_url
    click_on "Edit", match: :first

    fill_in "Shares", with: @holding.shares
    fill_in "Stock Symbol", with: @holding.stock_symbol
    fill_in "User", with: @holding.user_id
    click_on "Update Holding"

    assert_text "Holding was successfully updated"
    click_on "Back"
  end

  test "destroying a Holding" do
    visit holdings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Holding was successfully destroyed"
  end
end
