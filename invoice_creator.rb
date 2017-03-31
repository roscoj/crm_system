require "prawn"

class InvoiceCreater
  def initialize(invoice_data)
    # file name, invoice number, invoicee first and last name, invoicee address
    # handling descriptions, session date, session duration, cost of session
    # invoice total, invoice due date
    @invoice_data = [invoice_data]
  end

  def invoice_template(data)
    Prawn::Document.generate('file_name.pdf') do
      stroke_axis 
    end
  end
end
