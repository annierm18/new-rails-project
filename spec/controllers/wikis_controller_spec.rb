require 'rails_helper'
include RandomData

RSpec.describe WikisController, type: :controller do

  let(:my_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns [my_wiki] to @wikis" do
      get :index

      expect(assigns(:wikis)).to eq([my_wiki])
    end
  end



end
