module RecaptchaHelper

	def my_recaptcha_tags(options={})
		default_options = {:display => {lang: I18n.locale, theme: 'white'}}
		recaptcha_tags(default_options.merge(options))
	end
end