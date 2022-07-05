public class HomePageController {
    
    @AuraEnabled        
    public static List<Job_Posting__c> getJobPosting(String companyFilter, String postStatus) {
        String currentUser = UserInfo.getUserId();
        system.debug('fetchdata :'+UserInfo.getUserId());
        /*String currentUserName = UserInfo.getName();
        system.debug('fetchdataName :'+UserInfo.getName());
        
        List<CustomTeams__Team_Members__c> userTeam =  [Select CustomTeams__Team__r.Name from CustomTeams__Team_Members__c where CustomTeams__User__r.Name =: currentUserName];
        system.debug('userTeam>>>'+userTeam);*/
        
        /*String qryJobPosting ='Select Teams__c,Name,Posting_Due_Date__c,No_Of_Candidate_Selected__c,Job_OC_Status__c from Job_Posting__c';
        String qryjobPostingWhereClause = ' ' ;
        system.debug('qryJobPosting'+qryJobPosting);
        
        for(Integer i=0; i<userTeam.size(); i++){
            qryjobPostingWhereClause+=' (Teams__r.Name =\''+userTeam[i]+'\')';
            system.debug('qryjobPostingWhereClause'+qryjobPostingWhereClause);
        }
        qryJobPosting = qryJobPosting+ qryjobPostingWhereClause ;
        system.debug('qryJobPosting'+qryJobPosting);
        
        List<Job_Posting__c> listOfValues = Database.query(qryJobPosting);  
        
        System.debug('listOfValues'+listOfValues);*/
        //   String companyFilter = 'Sony India';
        String querry = 'Select Account__r.Name, Teams__c,Name,Posting_Due_Date__c,No_Of_Candidate_Selected__c,Job_OC_Status__c from Job_Posting__c WHERE Id <> null ';
        if(String.isNotBlank(companyFilter)){
            querry+= ' AND Account__r.Name = :companyFilter';
        }
        if(String.isNotBlank(postStatus)){
            querry+= ' AND Job_OC_Status__c = :postStatus';
        }
        System.debug(LoggingLevel.DEBUG, querry+'####Querry final');
        List<Job_Posting__c> listOfValues = Database.query(querry);
        system.debug('listOfValues>>>'+listOfValues);
        //Added by Dharshan
        for(Job_Posting__c values : listOfValues){
            if(values.Posting_Due_Date__c != null){
                //Due Date
                DateTime dueDate = values.Posting_Due_Date__c;
                System.debug('Due Date>>'+dueDate);
                String dueDateStr1 = dueDate.format('yyyy-MM-dd');
                System.debug('Due Date>>'+dueDateStr1);
                //Today date
                DateTime todaysDate = System.today();
                String todaysDateStr = todaysDate.format('yyyy-MM-dd');
                System.debug('Today date>>'+todaysDateStr);
                
                if(todaysDateStr > dueDateStr1){
                    values.Job_OC_Status__c = 'Closed';
                }
                update values;
            }
        }
        //ENDED by Dharshan  
        
        List<Job_Posting__c> lstOfAddedList = new List<Job_Posting__c>();
        for(Job_Posting__c teamMember : listOfValues){
            List<CustomTeams__Team_Members__c> lstOfMember = [Select CustomTeams__User__c from CustomTeams__Team_Members__c where CustomTeams__Team__c =: teamMember.Teams__c];
            for(CustomTeams__Team_Members__c member : lstOfMember){
                system.debug('fetchdata :'+UserInfo.getUserId());
                system.debug('member.CustomTeams__User__c'+member.CustomTeams__User__c);
                if(member.CustomTeams__User__c == UserInfo.getUserId()){
                    lstOfAddedList.add(teamMember);
                    system.debug('lstOfAddedList>>'+lstOfAddedList);
                }
            }
        }
        system.debug('Job_Posting__c>>>'+listOfValues);
        return lstOfAddedList;
    }
    
    @AuraEnabled
    public static Map<String,String> getClientList(){
        
            Map<String,String> clientList = new Map<String,String>();
        List<Job_Posting__c> client = [SELECT Account__r.Name, Name FROM Job_Posting__c WHERE Account__r.Name <> null];
        for (Job_Posting__c data : client) {
            System.debug(data);
            System.debug(data.Account__r.Name);
            clientList.put(data.Account__r.Id, data.Account__r.Name);

        }
        System.debug((clientList));
        return clientList;
    }

    @AuraEnabled
    public static Map<String,String> getStatusList(){
           Schema.DescribeFieldResult statusfield = Job_Posting__c.Job_OC_Status__c.getDescribe();
        Map<String,String> statusList = getPickListValuesIntoMap(statusfield);
        return statusList;
    }

    public static Map<String,String> getPickListValuesIntoMap(Schema.DescribeFieldResult objval){
        Map<String,String> pickListValuesMap= new Map<String,String>();
        List<Schema.PicklistEntry> ple = objval.getPicklistValues();
        if(!(ple.isEmpty())){
            for (Schema.PicklistEntry var : ple) {
                pickListValuesMap.put((var.getValue()).toUpperCase(), (var.getLabel()).toUpperCase());
            }
        }
         return pickListValuesMap;
     }

    @AuraEnabled
    public static  List<Job_Posting__c> togetJobPostings(String companyFilter, String postStatus){
        //System.debug('items>>.'+items);
        String currenUser = UserInfo.getUserId();
        system.debug('currenUser>>>'+currenUser);

        List<Account> userAccnts = new List<Account>();
        userAccnts = [Select Name from Account where CreatedById =: currenUser];
        system.debug('userAccnts>>'+userAccnts);

        List<Job_Posting__c> jobPostings = [Select Id,Name,Posting_Due_Date__c,No_Of_Candidate_Selected__c,Job_OC_Status__c,(Select Name,Job_Posting__c,Candidate_Profile__r.Designation__c,Candidate_Profile__r.Experience__c,Candidate_Profile__r.Skills__c,Candidate_Profile__r.Current_Location__c,Candidate_Profile__r.Notice_Period__c,Profile_Status__c,Status__c from Job_Applications__r) from Job_Posting__c where  Account__c IN :userAccnts];
        system.debug('jobPostings>>'+jobPostings);
        return jobPostings;
    }
    
     public class JobApplicantsWrap
    {
        @AuraEnabled public List<string> StatusButtons ;
        @AuraEnabled public Job_Posting__c JobPosting = new Job_Posting__c();
    }
    
   
}