module ApplicationHelper
	def flash_message
		message = ""
		close = content_tag :button, "x", :class => "close", "data-dismiss" => "alert", :type => "button"
		[:notice, :alert, :success, :error].each do |type|
			if(!flash[type].blank?)
				message += content_tag :div, "#{flash[type]} #{close}".html_safe, :class => "alert alert-#{(type == :notice) ? 'info' : type }"
			end	
		end
		message.html_safe
	end
end
