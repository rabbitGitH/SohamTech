public class ContactRegistrationController {
    public String selectedLanguage { get; set; }
    public Contact contact { get; set; }

    public ContactRegistrationController() {
        contact = new Contact();
    }

    public void saveContact() {
        try {
            insert contact;

            String noteContent = '';
            if (selectedLanguage == 'English') {
                noteContent = 'English note content';
            } else if (selectedLanguage == 'French') {
                noteContent = 'French note content';
            } else if (selectedLanguage == 'Spanish') {
                noteContent = 'Spanish note content';
            }

            if (String.isNotBlank(noteContent)) {
                Note note = new Note();
                note.Title = 'Language Note';
                note.Body = noteContent;
                note.ParentId = contact.Id;
                insert note;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Contact created successfully!'));
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred. Please try again.'));
        }
    }
}