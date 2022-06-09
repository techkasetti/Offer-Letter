public class HomePageController {
    
    @AuraEnabled        
    public static List<KTDO1__Job_Posting__c> getJobPosting() {
        String currentUser = UserInfo.getUserId();
        system.debug('fetchdata :'+UserInfo.getUserId());
        
        List<KTDO1__Job_Posting__c> lstOfValues = [Select KTDO1__Teams__c,Name,KTDO1__Posting_Due_Date__c,KTDO1__No_Of_Candidate_Selected__c,KTDO1__Job_OC_Status__c from KTDO1__Job_Posting__c];
        system.debug('KTDO1__Job_Posting__c>>>'+lstOfValues);
        
        //Added by Dharshan
        for(KTDO1__Job_Posting__c values : lstOfValues){
            if(values.KTDO1__Posting_Due_Date__c != null){
                //Due Date
                DateTime dueDate = values.KTDO1__Posting_Due_Date__c;
                System.debug('Due Date>>'+dueDate);
                String dueDateStr1 = dueDate.format('yyyy-MM-dd');
                System.debug('Due Date>>'+dueDateStr1);
                //Today date
                DateTime todaysDate = System.today();
                String todaysDateStr = todaysDate.format('yyyy-MM-dd');
                System.debug('Today date>>'+todaysDateStr);
                
                if(todaysDateStr > dueDateStr1){
                    values.KTDO1__Job_OC_Status__c = 'Closed';
                }
                update values;
            }
        }
        //ENDED by Dharshan  
        
        List<KTDO1__Job_Posting__c> lstOfAddedList = new List<KTDO1__Job_Posting__c>();
        for(KTDO1__Job_Posting__c teamMember : lstOfValues){
            List<CustomTeams__Team_Members__c> lstOfMember = [Select CustomTeams__User__c from CustomTeams__Team_Members__c where CustomTeams__Team__c =: teamMember.KTDO1__Teams__c];
            for(CustomTeams__Team_Members__c member : lstOfMember){
                system.debug('fetchdata :'+UserInfo.getUserId());
                if(member.CustomTeams__User__c == UserInfo.getUserId()){
                    lstOfAddedList.add(teamMember);
                    system.debug('lstOfAddedList>>'+lstOfAddedList);
                }
            }
        }
        return lstOfAddedList;
    }  
}