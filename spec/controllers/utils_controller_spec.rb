require 'spec_helper'

describe UtilsController do
	stub_abilities
	set_referer

	subject { response }

 	describe "POST markdown_preview :" do
 		describe "(unauthorized)" do
 			before { post :markdown_preview, data: '_underline_ *italic*' }
			its_access_is "unauthorized"
	 	end
	 	# describe "(authorized)" do
	 	# 	before do
	 	# 		@ability.can :markdown_preview, :utils
 		# 		post :markdown_preview, data: '_underline_ *italic*'
 		# 	end
 		# 	it 'should output html' do
 		# 		assigns(:content).should_not be_empty
			# end
	 	# end
 	end
end
