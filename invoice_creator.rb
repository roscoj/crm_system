require "prawn"

class InvoiceCreater

  # data strcuture for invoice details an array of hashes
  def initialize(invoice_data)
    @invoice_data = [invoice_data]
  end

  def invoice_template(data)
    Prawn::Document.generate('implicit.pdf') do
      text content
    end
  end
end
