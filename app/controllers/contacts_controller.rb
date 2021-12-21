class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def confirm
    @contact  = Contact.new(contact_params)
    if @contact.valid?
      render :confirm
    else
      render :new
      flash[:alert] = @contact.errors.full_messages
    end
  end

  def complete
    @contact = Contact.new(contact_params)
    ContactMailer.received_email(@contact).deliver
    render :complete
  end

  private
  def contact_params
    params.permit(:name, :email, :message)
  end
end
