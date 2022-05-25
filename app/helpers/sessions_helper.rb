# frozen_string_literal: true

module SessionsHelper
  def session_symbol(name, path = nil)
    full_path = path&.split("?") || request.fullpath.split("?")
    session_path = full_path.first.split("/")
    "#{session_path.second_to_last}_#{session_path.last}_#{name}"
  end

  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) unless user.nil?
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    alt = user.nil? ? "no log in" : user.email
    image_tag(gravatar_url, alt: alt, class: "rounded-full")
  end
end
