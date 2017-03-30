# CRM System #

# Description of Software Structure/Functionality #

**Index page:**

1. List of all active clients in link form
2. Add new client button
3. Invoicing
4. Send request to GoCardless


**Individual Client page:**

1. Client details: Name, email, home address, telephone
2. Edit client details
3. Archive pupil
4. Link to archive of client invoices


**Invoicing Page**

1. List of active clients
2. Current balance (based on dates)
3. Dropdown for Create Invoice on Balance
4.
5. Dropdown for Request Payment Today Via GoCardless
6. Date "from" and "to" filter (with refresh)
7. Submit button

*Functionality:*
- Create a pdf invoice with individual invoice number
- Attach invoice to email and send email to client
- Integration needed with Google Calendar
- Integration needed with GoCardless


Next steps
- Need to integrate the google calendar API, pull some data and experiment with how to manipulate it
- Then need to experiment with making pdfs using a gem
- Then need to understand how to attach and send emails using a gem
- Once data is in a suitable state, pdf is workable, emailing is workable, we can think about using google data to produce a pdf printout ready for testing.
