require 'prawn'

Prawn::Document.generate('file_name.pdf') do
  text "Hello world"
end

