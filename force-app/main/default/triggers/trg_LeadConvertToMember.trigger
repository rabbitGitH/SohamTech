trigger trg_LeadConvertToMember on Lead (after update) {
  // Make a list of leads to convert
  List<Lead> leadsToConvert = new List<Lead>();
  for (Lead l : Trigger.new) {
    if (l.Status == 'Member') {
      leadsToConvert.add(l);
    }
  }
  
  // Create the special conversion object
  SpecialLeadConvert slc = new SpecialLeadConvert(leadsToConvert);
  
  // Use the object's method to convert its leads
  slc.convertToMembers();
  
  // Don't forget to use System.debug!
  System.debug('Members created: ' + slc.getMembers());
}