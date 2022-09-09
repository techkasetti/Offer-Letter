@IsTest
public with sharing class CandFieldSetTest {
    @isTest(seeAllData=false)
    public static void CandFieldSetTest1() {

        Account account = new Account();
        account.Name = 'Sony India';
        insert account;
        
        Contact con = new Contact();
        con.AccountId = account.Id;
        con.LastName = 'B K';
        insert con;

            User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'FirstName',
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',     
            ContactId = con.id
            );

            CustomTeams__Teams__c team = new CustomTeams__Teams__c();
            team.Name = 'Team Anil';
         
            insert team;
        
               
       // Candidate_Profile__c cndprfl=new Candidate_Profile__c();
       // cndprfl.Name='Akash M';
       // cndprfl.Email__c='akashmedar83@gmail.com';
       // insert cndprfl;

            Job_Posting__c jobPost = new Job_Posting__c();
            jobPost.Name = 'Job Sony';
            jobPost.Posting_Due_Date__c =  Date.newInstance(2022, 06, 30);
            jobPost.Job_OC_Status__c = 'Open';
            jobPost.No_Of_Candidate_Selected__c = 10;
            //jobPost.Contact__c= con.Id;
            jobPost.Teams__c = team.Id;
            jobPost.Account__c = account.Id;
            insert jobPost;

            Candidate_Profile__c candProfile = new Candidate_Profile__c();
            candProfile.Name = 'nandu';
            candProfile.Email__c = 'nandu1@gmail.com';
            candProfile.Id=candProfile.Id;
            insert candProfile;
        
            
        
            List<String> listString = new List<String>();
            listString.add('Ram');
            listString.add(candProfile.Id);
            listString.add(jobPost.Id);
        
            List<String> listSkillExp = new List<String>();
            listSkillExp.add('JavaScript');
                

            Skill_Set__c skillSet4 = new Skill_Set__c();
            skillSet4.Name = 'Html';
            skillSet4.Department__c = 'IT';
            insert skillSet4;

            Skill_Set__c skillSet5 = new Skill_Set__c();
            skillSet5.Name = 'C Language';
            skillSet5.Department__c = 'IT';
            insert skillSet5;

            List<Skill_Set_Experience__c> skillSetExpList = new List<Skill_Set_Experience__c>();
            Skill_Set_Experience__c skillSetExp1 = new Skill_Set_Experience__c();
            skillSetExp1.Name = 'Html';
            skillSetExp1.SkillSet_Experience__c = '3';
            skillSetExp1.Job_Posting__c = jobPost.Id;
            skillSetExp1.Ratings__c = '5';
            skillSetExp1.Skill_Set__c = skillSet4.Id;
            skillSetExp1.Candidate_Profile__c = candProfile.Id;
            skillSetExpList.add(skillSetExp1);
    
            Skill_Set_Experience__c skillSetExp2 = new Skill_Set_Experience__c();
            skillSetExp2.Name = 'C Language';
            skillSetExp2.SkillSet_Experience__c = '3';
            skillSetExp2.Job_Posting__c = jobPost.Id;
            skillSetExp2.Ratings__c = '9';
            skillSetExp2.Skill_Set__c = skillSet5.Id;
            skillSetExp2.Candidate_Profile__c = candProfile.Id;
            skillSetExpList.add(skillSetExp2);
    
            insert skillSetExpList;
        
       
        
        
        

        CandFieldSet.searchProfiles('{"sobjectType":"Candidate_Profile__c","Notice_Period__c":"Immediate","Designation__c":"Salesforce Developer","Email__c":"akhilesh@gmail.c"}',skillSetExpList);
            
        CandFieldSet.getFieldSetMemberClone('Basic_Information_FieldSet');
            
        CandFieldSet.getsObjects();
          
        CandFieldSet.getFieldSet('Candidate_Profile__c','Basic_Information_FieldSet'); 
        
        CandFieldSet.getJSONFieldSet('Candidate_Profile__c','Basic_Information_FieldSet');
        
        CandFieldSet.getFieldSetMember('Candidate_Profile__c','Basic_Information_FieldSet');
        
        CandFieldSet.getSkillSets('IT');
        
        CandFieldSet.getJobPostingPickListValues(jobPost.id);
       
        CandFieldSet.getJobPostingValues(jobPost.id,candProfile.Id);
        
        CandFieldSet.saveJobApplication(listString);
        
        CandFieldSet.getCandidateResume(candProfile.Id);
       
        CandFieldSet.getSkillSetsDepartment();
        
        CandFieldSet.getClientPicklistValues();
        
        String serialise = JSON.serialize(candProfile);
        
        CandFieldSet.doUpsertObjects(serialise,listSkillExp);
        
        CandFieldSet.getFieldSet('Candidate_Profile__c');
            
   }
}