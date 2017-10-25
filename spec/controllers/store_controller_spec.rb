require 'rails_helper'

describe StoreController do
  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns a list of foods, ordered by name" do
      nasi_uduk = create(:food, name: "Nasi Uduk")
      kerak_telor = create(:food, name: "Kelar Telor")
      get :index
      expect(assigns(:foods)).to eq([kerak_telor, nasi_uduk])
    end
  end
end
