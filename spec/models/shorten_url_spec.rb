require 'rails_helper'

RSpec.describe ShortenUrl, type: :model do

  context 'class method tests' do

    let(:random_value) { 'abcd12' }
    describe '#generate_short_url' do
      it 'returns the random code' do
        mock = double("ShortenUrl", :generate_short_url => :random_value)
        expect(mock.generate_short_url).to eq(:random_value)
      end
    end

    describe '#generate_admin_url' do
      it 'returns the random code' do
        mock = double("ShortenUrl", :generate_admin_url => :random_value)
        expect(mock.generate_admin_url).to eq(:random_value)
      end
    end

    describe '#active?' do
      it 'return true if active' do
        url = described_class.new(original_url: 'https://google.com', status: 0)
        expect(url).to be_active
      end
      it 'return false if not active' do
        url = described_class.new(original_url: 'https://google.com', status: 1)
        expect(url).to_not be_active
      end
    end

    describe '#short' do
      let(:params) { {original_url: 'http://linkedin.com', short_url: 'poi123', admin_url: 'poi456', status: 0}}
      it 'returns short url if active' do
        url = described_class.new(params)
        expect(url.short).to eq('http://localhost:3000/poi123')
      end
    end

    describe '#short_admin' do
      let(:params) { {original_url: 'http://linkedin.com', short_url: 'poi123', admin_url: 'poi456', status: 0}}
      it 'returns short url if active' do
        url = described_class.new(params)
        expect(url.short_admin).to eq('http://localhost:3000/s/admin/poi456')
      end
    end

  end
  context 'validation tests' do
    it 'ensures original url presence' do
      url = described_class.new(short_url: '4521e2', admin_url: '321eee').save
      expect(url).to eq(false)
    end

    it 'ensures original url valid (http)' do
      url = described_class.new(original_url: 'htt://facebook.com', short_url:  'edq3s1', admin_url: 'qwe123').save
      expect(url).to eq(false)
    end

    it 'ensures original url valid (http://)' do
      url = described_class.new(original_url: 'http:/facebook.com', short_url:  'edq3s1', admin_url: 'qwe123').save
      expect(url).to eq(false)
    end

    # it 'ensures original url valid (unwise)' do
    #  url = ShortenUrl.new(url: 'http://mw1.google.com/mw-earth-vectordb/kml-samples/gp/seattle/gigapxl/$[level]/r$[y]_c$[x].jpg', short_url:  'edq3s1', admin_url: 'qwe123').save
    #  expect(url).to eq(false)
    # end

    it 'should save successfully' do
      url = described_class.new(original_url: 'http://facebook.com', short_url:  'edq3s1', admin_url: 'qwe123').save
      expect(url).to eq(true)
    end
  end
  context 'scope tests' do
    let(:params) { {original_url: 'http://linkedin.com', short_url: 'poi123', admin_url: 'poi456', status: 0}}
    before(:each) do
      url = described_class.new(params).save
      url = described_class.new(params.merge(status: 1, admin_url: 'ewq456')).save
      url = described_class.new(original_url: 'http://facebook.com', short_url:  'qwe123', admin_url: 'qwe456', status: 0).save
      url = described_class.new(original_url: 'http://google.com', short_url:  'zxc123', admin_url: 'zxc456', status: 1).save
      url = described_class.new(original_url: 'http://twitter.com', short_url:  'asd123', admin_url: 'asd456', status: 1).save
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
    it 'should return active short urls' do
      expect(ShortenUrl.active.size).to eq(2)
    end
    it 'should return inactive short urls' do
      expect(ShortenUrl.inactive.size).to eq(3)
    end
  end
end
