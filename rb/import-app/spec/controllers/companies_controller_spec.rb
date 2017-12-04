require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let!(:bax) { FactoryBot.create(:company, name: "Bax") }

  let(:json_body) { JSON.parse(response.body) }

  describe "GET #index" do
    it 'gives proper null and 0 data when there is nothing' do
      get :index
      expect(json_body.length).to eq 1
      expect(json_body[0]["comp"]["name"]).to eq "Bax"
      expect(json_body[0]["comp"]["op"]).to eq({"noops"=>0, "opsacp"=>0, "avgamt"=>nil, "mohigh"=>nil})
    end

    context 'when there is ops data' do
      before do
        amts = [10, 20, 30, 40, 50]
        5.times do |i|
          FactoryBot.create(:operation, :accepted, company: bax, amount: amts[i]) 
          FactoryBot.create(:operation, :rejected, company: bax, amount: amts[i])
          FactoryBot.create(:operation, :accepted, company: bax, operation_date: 1.month.ago, amount: amts[i]) 
        end
        FactoryBot.create(:operation, :accepted, company: bax, operation_date: 1.month.ago, amount: 1800) 
      end

      it 'gives proper calculation' do
        get :index
        expect(json_body[0]["comp"]["op"]).to eq({
          "noops"=>16, "opsacp"=>11, "avgamt"=>140.63, "mohigh"=>50.0
        })
      end
    end
  end
end
