class CustomerSideMailer < ApplicationMailer

  def order_confirm_mail(data)
    email_id = data.user.email
    sales_team_email_cc = Rails.application.config.company_email_addresses["sales_cc"]
    subject = 'Successful Order Craeted'
    mail(to: email_id, subject: subject, cc: sales_team_email_cc)
  end

end
