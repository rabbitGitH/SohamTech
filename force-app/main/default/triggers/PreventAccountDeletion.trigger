trigger PreventAccountDeletion on Account (before delete) {
    Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

    for (Account acc : Trigger.old) {
        if (acc.Id == Trigger.oldMap.get(acc.Id).Id && UserInfo.getProfileId() != systemAdminProfile.Id) {
            acc.addError('Only system administrators are allowed to delete accounts.');
        }
    }
}