require 'spec_helper'

describe SortPresenter do
	let(:options) { ['tata', 'titi', 'toto'] }

  before do
    @sort_presenter = SortPresenter.new options
  end

  subject { @sort_presenter }

  describe 'reponds :' do
  	it { should respond_to(:sort_by) }
    it { should respond_to(:options_for_select) }
  end

  describe 'constructor :' do
  	it 'should raise if no argument is provided' do
  		expect { SortPresenter.new }.to raise_error(ArgumentError)
  	end
  	it 'should raise if first arg is not an array of strings or symbol' do
  		expect { SortPresenter.new [1, 'toto'] }.to raise_error(ArgumentError)
  		expect { SortPresenter.new [:tata, 'toto'] }.to_not raise_error(ArgumentError)
  	end
  	describe 'should set sort_by as first options by default' do
  		its(:sort_by) { should == :tata }
  	end
  	describe 'when proviing a second argument' do
  		before { @sort_presenter = SortPresenter.new options, "TOto" }
  		it 'should raise if second argument is not a valid option' do
  			expect {  SortPresenter.new options, "not_good" }.to raise_error(ArgumentError)
  		end
  		describe 'should set sort_by with the value of second argument' do
  			its(:sort_by) { should == :toto }
  		end
  	end
  end
  describe 'Methods :' do
    describe 'options_for_select' do
      its(:options_for_select) { should be_a Array }
    end
  end
end