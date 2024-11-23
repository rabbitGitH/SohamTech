public class SpecialLeadConvert {
  
  // Variables
  List<Lead>      leads;
  List<Member__c> members;
    
  // Constructor  
  public SpecialLeadConvert(List<Lead> leadList) {
    leads   = leadList;
    members = new List<Member__c>();
  }
    
  // Method: our special conversion
  public void convertToMembers() {
    // Convert to Members instead of Contacts
    for (Lead l : leads) {
      Member__c member = new Member__c();
      member.Name     = l.FirstName + ' ' + l.LastName;
      member.Email__c = l.Email;
      members.add(member);
    }
    insert members;
    
    // Delete the leads 
    // Apex doesn't let us delete records in Trigger.new
    // This is a workaround that tricks Apex!
    List<Lead> workaround = leads.deepClone(true);
    delete workaround;
  }
    
  // Method: get our Member list  
  public List<Member__c> getMembers() {
    return members;
  }
}