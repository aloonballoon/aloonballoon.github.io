require 'rails_helper'

feature 'Adding Comments (hint: make sure your capitalization is exact!)', type: :feature do
  before :each do
    register_as_quinn_leong
  end

  it 'has an add Comment form on the product show page' do
    make_product
    expect(page).to have_content('Add Comment')
  end

  it 'shows the product show page on submit' do
    make_product('chores')
    fill_in 'Body', with: 'Clean Room'
    click_button 'Add Comment'
    expect(page).to have_content('chores')
  end

  it 'adds the Comment to the product on clicking the submit button' do
    make_product
    fill_in 'Body', with: 'Clean Room'
    click_button 'Add Comment'
    expect(page).to have_content('Clean Room')
  end
end

feature 'Deleting comments' do
  before :each do
    register_as_quinn_leong
    make_product
    add_comment
  end

  it 'displays a remove button next to each comment' do
    expect(page).to have_button('Remove Comment')
  end

  it 'shows the product show page on click' do
    click_button 'Remove Comment'
    expect(current_path).to eq(product_path(Product.last))
  end

  it 'removes the Comment on click' do
    click_button 'Remove Comment'
    expect(page).to_not have_content('be awesome')
  end
end
