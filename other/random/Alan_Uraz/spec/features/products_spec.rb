require 'rails_helper'

feature 'Creating a product (hint: make sure your capitalization is exact!)', type: :feature do
  context 'when logged in' do
    before :each do
      register_as_quinn_leong
      visit new_product_url
    end

    it 'takes a title, a price, and a description' do
      expect(page).to have_content('Title')
      expect(page).to have_content('Price')
      expect(page).to have_content('Description')
    end

    context 'on failed save' do
      before :each do
        make_product('', 100.00, 'Rad things task')
      end

      it 'has a pre-filled form (with the data previously input)' do
        expect(find_field('Price').value).to have_content('100')
        expect(find_field('Description').value).to eq('Rad things task')
      end

      it 'still allows for a successful save' do
        fill_in 'Title', with: 'My First Product'
        click_button 'Create New Product'
        expect(page).to have_content('My First Product')
      end
    end
  end
end

feature 'Seeing all products' do
  context 'when logged in' do
    before :each do
      register_as_quinn_leong
      make_product('My First Product', 100.00)
      make_product('My Second Product', 199.99)
      visit products_path
    end

    it 'shows all the products that exist' do
      expect(page).to have_content('My First Product')
      expect(page).to have_content('My Second Product')
    end

    it 'links to each of the products with the product titles' do
      click_link 'My First Product'
      expect(page).to have_content('My First Product')
      expect(page).to_not have_content('My Second Product')
    end
  end

  context 'when signed in as another user' do
    before :each do
      register('quinn_leong')
      click_button 'Sign Out'
      register('goodbye_world')
      make_product('Goodbye cruel world')
      click_button 'Sign Out'
      sign_in('quinn_leong')
    end

    it 'does show others products' do
      visit products_path
      expect(page).to have_content('Goodbye cruel world')
    end
  end
end

feature 'Showing a product' do
  context 'when logged in' do
    before :each do
      register('quinn_leong')
      make_product('Hello, World!', 100.00, 'Rad things to do.')
      visit products_path
      click_link 'Hello, World!'
    end

    it 'displays the product title' do
      expect(page).to have_content('Hello, World!')
    end

    it 'displays the product price' do
      expect(page).to have_content('100')
    end

    it 'displays the product description' do
      expect(page).to have_content('Rad things to do.')
    end
  end
end

feature 'Editing a product' do
  before :each do
    register_as_quinn_leong
    make_product('This is a title', 100.00, 'This is a description')
    visit products_path
    click_link 'This is a title'
  end

  it 'has a link on the show page to edit a product' do
    expect(page).to have_content('Edit Product')
  end

  it 'shows a form to edit the product' do
    click_link 'Edit Product'
    expect(page).to have_content('Title')
    expect(page).to have_content('Price')
    expect(page).to have_content('Description')
  end

  it 'has all the data pre-filled' do
    click_link 'Edit Product'
    expect(find_field('Title').value).to eq('This is a title')
    expect(find_field('Description').value).to eq('This is a description')
  end

  context 'on successful update' do
    let!(:show_page) { current_path }

    before :each do
      click_link 'Edit Product'
    end

    it 'redirects to the product show page' do
      fill_in 'Title', with: 'A new title'
      click_button 'Update Product'
      expect(page).to have_content('A new title')

      expect(current_path).to eq(show_page)
    end
  end

  context 'on a failed update' do
    let!(:show_page) { current_path }

    before :each do
      click_link 'Edit Product'
    end

    it 'returns to the edit page' do
      fill_in 'Title', with: ''
      click_button 'Update Product'

      # failed; should be able to try again
      fill_in 'Title', with: 'Ginger Baker\'s Product'
      click_button 'Update Product'

      expect(current_path).to eq(show_page)
      expect(page).to have_content('Ginger Baker\'s Product')
    end

    it 'preserves the attempted updated data' do
      fill_in 'Title', with: ''
      click_button 'Update Product'

      expect(find_field('Title').value).to eq('')
    end
  end
end
