class ClientMessenger < SimpleMessaging::Messenger

  def order_confirm_sms(attributes)
    send_message to: attributes
  end

end
