Public class CandFieldSet {

    @AuraEnabled 
   public static List<String> getsObjects(){
       System.debug('sObjectList>>>');
       List<String> sObjectList = new List<String>();
       FOR(Schema.SObjectType sObj : Schema.getGlobalDescribe().values()){
           // Show only those objects which have atleast one Field Set
           Map<String, Schema.FieldSet> FieldSetMap = sObj.getDescribe().fieldSets.getMap();
           if(FieldSetMap!=null && FieldSetMap.keySet().size() > 0){
               sObjectList.add(sObj.getDescribe().getName() +'####'+sObj.getDescribe().getLabel());
           }
       }
       System.debug('sObjectList>>>'+sObjectList);
       return sObjectList;
   }
   
   @AuraEnabled 
   public static List<String> getFieldSet(String sObjectName){
       Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectName);
       List<String> fieldSetList = new List<String>();
       
       FOR(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values()){
           fieldSetList.add(fs.getName() +'####'+fs.getLabel());
       }
       System.debug('fieldSetList>>>'+fieldSetList);
       return fieldSetList;
   }
   
   @AuraEnabled 
   public static String getFieldSetMember(String objectName , String fieldSetName){
       SYSTEM.debug('objectName>>'+objectName);
       SYSTEM.debug('fieldSetName>>'+fieldSetName);
       String dha = ''+fieldSetName;
       SYSTEM.debug('dha>>'+dha);
       List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
       Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
       SYSTEM.debug('sObj>>'+sObj);
       SYSTEM.debug('sObjFilds>>'+sObj.getDescribe().fieldSets.getMap().get(dha).getFields());
       
       for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(dha).getFields()){
           FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
           wrapper.isDBRequired = fieldMember.getDbRequired();
           wrapper.isRequired = fieldMember.getRequired();
           wrapper.fieldType = String.valueOf(fieldMember.getType());
           wrapper.fieldLabel = fieldMember.getLabel();
           wrapper.fieldAPIName = fieldMember.getFieldPath();
           if(String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
              String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST'){
                  wrapper.pickListValues = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                      .getDescribe().getPicklistValues();
              }
           wrapperList.add(wrapper);
       }
       SYSTEM.debug('getFieldSetMember>>'+JSON.serialize(wrapperList));
       return JSON.serialize(wrapperList);
   }
   
    @AuraEnabled 
   public static String getFieldSetMemberClone(String fieldSetName){
       system.debug('fieldSetName >>>>'+fieldSetName);
      // String spliteVals = fieldSetName[0];
      // system.debug('spliteVals ::::::'+spliteVals);
       String objectName =  'Candidate_Profile__c'; 
       SYSTEM.debug('objectName>>'+objectName);
         Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
       List<String> fieldSetList = new List<String>();
       FOR(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values()){
           fieldSetList.add(fs.getName());
       }
       List<String> fieldSetListNew = new List<String>();
       System.debug('fieldSetList>>>'+fieldSetList);
       for(String fieldSetListmembr : fieldSetList){
            Boolean result = 
  fieldSetName.contains(fieldSetListmembr);
       system.debug('result>>>>'+result);
           if(result){
           fieldSetListNew.add(fieldSetListmembr);
       }
       }
      
       List<String> listdha = new List<String>();
         for(String strList : fieldSetListNew){
          String dha = ''+strList;
           system.debug('dha >>>>>>>'+dha);
           listdha.add(dha);
        }
       system.debug('listdha >>>>>>>'+listdha);
        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        FieldSetWrapperClass memberClass = new FieldSetWrapperClass();
           
       Schema.SObjectType sObjects = Schema.getGlobalDescribe().get(objectName);
       SYSTEM.debug('sObjects>>'+sObjects);
       
      // SYSTEM.debug('sObjFilds>>'+sObjects.getDescribe().fieldSets.getMap().get(dha).getFields());
        List<String> listsObjFilds = new List<String>();
      // String dha = new String();
       for(String strList : listdha){
         // String sObjFilds = sObjects.getDescribe().fieldSets.getMap().get(strList).getFields());
          // system.debug('strList >>>>>>>'+strList);
          // listsObjFilds.add(sObjFilds);
           
      
       //system.debug('listsObjFilds >>>>>>>'+listsObjFilds);
       for(Schema.FieldSetMember fieldMember : sObjects.getDescribe().fieldSets.getMap().get(strList).getFields()){
           FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
           wrapper.isDBRequired = fieldMember.getDbRequired();
           wrapper.isRequired = fieldMember.getRequired();
           wrapper.fieldType = String.valueOf(fieldMember.getType());
           wrapper.fieldLabel = fieldMember.getLabel();
           wrapper.fieldAPIName = fieldMember.getFieldPath();
           if(String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
              String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST'){
                  wrapper.pickListValues = sObjects.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                      .getDescribe().getPicklistValues();
              }
           wrapperList.add(wrapper);
       }
           system.debug(' dh ::::::::::'+strList);
           memberClass.FSName = strList;
            memberClass.membertList = wrapperList;
            }
      /* SYSTEM.debug('getFieldSetMember>>'+JSON.serialize(wrapperList));
       FieldSetWrapperClass memberClass = new FieldSetWrapperClass();
       memberClass.membertList = wrapperList;*/
       system.debug('memberClass >>>>>'+memberClass);
       return JSON.serialize(memberClass);
   }
   
   @AuraEnabled
   public static  List<Candidate_Profile__c> doUpsertObjects(String objectData , List<String> skillList){
       system.debug('skillList >>>>>>>>>'+skillList); 
         Candidate_Profile__c caseObj = (Candidate_Profile__c)JSON.deserialize(objectData,Candidate_Profile__c.class);
        /*sObject contactsForUpdate = (sObject) JSON.deserialize(
           objectData,
           Type.forName('Candidate_Profile__c'));*/
              system.debug('skillList >>>>>>>>>'+skillList.size()+'sdf'+skillList.size()); 
       if(skillList.size()>0){
       string skills = ' ';
       if(skillList.size() ==1){
           skills = ' AND Name ='+'\''+skillList[0]+'\'';
       }
       else{
        //for(String liststring : skillList){
           for(integer i=0;i<skillList.size() ;i++){
            skills += ' AND Name ='+'\''+skillList[i]+'\'';
        }
       }
       system.debug('skills   >>>>'+skills);
       }
       List<Skill_Set_Experience__c > skillsetExp = [Select Id , Name ,Candidate_Profile__c From Skill_Set_Experience__c where Name IN:skillList];
        system.debug('skillsetExp >>>>>>>>>'+skillsetExp);
       Set<String> candIds = new Set<String>();
      
       for(Skill_Set_Experience__c listIds : skillsetExp){
           if(listIds.Candidate_Profile__c != null){
              candIds.add('\''+listIds.Candidate_Profile__c+'\'');    
                //candIds.add(listIds.Candidate_Profile__c);    
           }
        }
        List<String> listStrings = new List<String>();
       listStrings.addAll(candIds);
       system.debug('listStrings  ::::::'+listStrings);
      // upsert objectData;
       String searchquery;
       searchquery = 'SELECT Id , Name , Designation__c,Expected_CTC__c , Notice_Period__c From Candidate_Profile__c Where Notice_Period__c ='+ '\''+ caseObj.Notice_Period__c + '\' AND  Designation__c ='+ '\''+ caseObj.Designation__c + '\'';
       if(listStrings.size()>0){
            searchquery +=' AND Id IN '+listStrings;
       }
        
      system.debug('searchquery >>>>>>>>>'+searchquery);
       List<Candidate_Profile__c> records = Database.query(searchquery);
        system.debug('records >>>>>>>>>'+records);
       return records;
   }
   
    @AuraEnabled
   public static List<String> getSkillSets(String selectedDeparment){
       List<Skill_Set__c> skillSets = [Select id , Name From Skill_Set__c where Department__c =: selectedDeparment ];
       system.debug('skillSets >>>>>>'+skillSets);
       List<String> listVals = new List<String>();
       for(Skill_Set__c individualskill :skillSets ){
           listVals.add(individualskill.Name);
       }
       system.debug('listVals   >>>>'+listVals);
       return listVals;
       
   }
   
    @AuraEnabled
   public static List<String> getSkillSetsDepartment(){
       List<String> listVals = new List<String>();
       Schema.DescribeFieldResult fieldResult = Skill_Set__c.Department__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry pickListVal : ple){
           listVals.add(pickListVal.getLabel());
       }
       system.debug('listVals   >>>>'+listVals);
       return listVals;
       
   }
   
   @AuraEnabled
   public static  List<Candidate_Profile__c> searchProfiles(String parentobjectData ,List<Skill_Set_Experience__c> objectData){
         Candidate_Profile__c caseObj = (Candidate_Profile__c)JSON.deserialize(parentobjectData,Candidate_Profile__c.class);
       system.debug('caseObj    >>>>>'+caseObj);
       system.debug('objectData >>>>>>>>>'+objectData); 
       set<String> candidateIds = new set<String>();
       set<String> finalcandidateIds = new set<String>();
       List<String> lst =new List<String>();
         List<String> candidatelst =new List<String>();
       string conditionstr;
       // for(Skill_Set_Experience__c skillsetlst : objectData){
       for(Integer i=0 ; i< objectData.size() ;i++){
           system.debug('i >>>>>'+i);
           conditionstr = 'SELECT id , Candidate_Profile__c FROM Skill_Set_Experience__c WHERE Candidate_Profile__c <> null AND ' ;
           if(candidateIds.size()==0){
               conditionstr += ' ('+ 'Skill_Set__c = ' +  '\'' + objectData[i].Skill_Set__c + '\'' +' AND Ratings__c = ' +  '\'' +  objectData[i].Ratings__c + '\'' + ' AND Skill_Experience_Level__c  >= '+  '\'' +  objectData[i].Min_Experiance__c + '\'' +' AND Skill_Experience_Level__c  <=' + '\'' +  objectData[i].Max_Experiance__c  + '\'' +') ';
               system.debug('conditionstr   :::::'+conditionstr);
           }
           else{
               conditionstr += ' ('+ 'Skill_Set__c = ' +  '\'' +  objectData[i].Skill_Set__c + '\'' +' AND Ratings__c = ' +  '\'' +  objectData[i].Ratings__c + '\'' + ' AND Skill_Experience_Level__c  >= '+  '\'' +  objectData[i].Min_Experiance__c + '\'' +' AND Skill_Experience_Level__c  <=' + '\'' +  objectData[i].Max_Experiance__c  + '\'' +') '+ ' AND Candidate_Profile__c  IN '+lst;
            }
            system.debug(' Final Queryconditionstr   :::::'+conditionstr);
           List<Skill_Set_Experience__c> records = Database.query(conditionstr);
           system.debug('records    Skill:::::'+records);
           candidateIds.clear();
           lst.clear();
           for(Skill_Set_Experience__c lststr :records){
               if(i == objectData.size()-1 ){
                   finalcandidateIds.add('\'' +lststr.Candidate_Profile__c + '\'');
               }else{
                   candidateIds.add('\'' +lststr.Candidate_Profile__c + '\'');     
               }
           }
           system.debug('candidateIds   >>>> '+candidateIds);
           lst.addAll(candidateIds);
           system.debug('lst   >>>>'+lst);
           candidatelst.addAll(finalcandidateIds);
       }
       
        String searchquery;
       searchquery = 'SELECT Id , Name ,Expected_CTC__c ,Current_CTC__c,Current_Location__c,Preferred_Location__c,Employers__c, Notice_Period__c, Designation__c, Email__c, Phone__c From Candidate_Profile__c Where Name <> null ';
        if(String.isNotBlank(caseObj.Name)){
           searchquery += ' AND Name like \'%'+caseObj.Name+'%\'';
       }
       if(String.isNotBlank(caseObj.Notice_Period__c)){
           searchquery += ' AND Notice_Period__c like \'%'+caseObj.Notice_Period__c+'%\'';
       }
       if(String.isNotBlank(caseObj.Designation__C)){
        searchquery +=    ' AND Designation__C like \'%'+caseObj.Designation__C+'%\'';
       }
        if(String.isNotBlank(caseObj.Email__c)){
        searchquery +=  ' AND Email__c like \'%'+caseObj.Email__c+'%\'';
       }
        if(String.isNotBlank(caseObj.Phone__c)){
        searchquery +=  ' AND Phone__c like \'%'+caseObj.Phone__c+'%\'';
       }
       if(candidatelst.size() >0){
           searchquery +=  'AND id IN '+candidatelst ;
       }
       system.debug('searchquery >>>>>>>>>'+searchquery);
       List<Candidate_Profile__c> profileRecords = Database.query(searchquery);
        //system.debug('records >>>>>>>>>'+records);
      // List<Candidate_Profile__c> profileRecords = [SELECT Id , Name , Designation__c,Expected_CTC__c , Notice_Period__c From Candidate_Profile__c Where id IN:finalcandidateIds];
       system.debug('profileRecords    :::::'+profileRecords);
       return profileRecords;
   }
   
   public class FieldSetWrapperClass{
       @AuraEnabled
       public String FSName 					 { get; set; }
       @AuraEnabled 
       public List<FieldSetMemberWrapperClass> membertList { get; set; }
   }
   
   public class FieldSetMemberWrapperClass{
       
       @AuraEnabled
       public Boolean isDBRequired 					 { get; set; }
       @AuraEnabled
       public Boolean isRequired 						 { get; set; }
       @AuraEnabled
       public String fieldType 						 { get; set; }
       @AuraEnabled
       public String fieldLabel 						 { get; set; }
       @AuraEnabled
       public String fieldAPIName 					     { get; set; }
       @AuraEnabled 
       public List<Schema.PicklistEntry> pickListValues { get; set; }
       
   }
   
   
   
   
   @AuraEnabled
   public static String getJSONFieldSet(String sObjectName,String sFieldSetName){
       String sFieldSet='';
       sFieldSet=getFieldSet(sObjectName,sFieldSetName);
       return sFieldSet;
   }    
   
   public static String getFieldSet(String sObjectName,String fieldSetName) {
       String result = '';
       try{
           SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
           Schema.DescribeSObjectResult d = objToken.getDescribe();
           Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
           system.debug('>>>>>>> FsMap >>> ' + FsMap);
           if(FsMap.containsKey(fieldSetName))
               for(Schema.FieldSetMember f : FsMap.get(fieldSetName).getFields()) {
                   
                   if(result != ''){
                       result += ',';
                   }
                   String jsonPart = '{';
                   jsonPart += '"helpText":"' + gethelpText(sObjectName,f.getLabel()) + '",';
                   jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                   jsonPart += '"type":"' + (f.getType()) + '",';
                   jsonPart += '"label":"' + (f.getLabel()) + '",';
                   jsonPart += '"name":"' + f.getFieldPath() + '"';
                   jsonPart += '}';
                   result += jsonPart;
               }
       }
       catch(Exception e){
           result += e.getLineNumber() + ' : ' + e.getMessage();
       }
       return '['+result+']';
   }
   
   public static string gethelpText(String sObjectName,String sField){
       String helptext='';
       String[] types = new String[]{sObjectName};
           List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(types);
       for (Schema.DescribeSobjectResult result : results) {
           Map<String, Schema.SObjectField> fieldMap = result.fields.getMap();
           for(String fieldName :  fieldMap.keySet()){
               Schema.SObjectField field = fieldMap.get(fieldName);
               Schema.DescribeFieldResult f = field.getDescribe();
               if(f.getLabel()==sField){helptext=f.getInlineHelpText();
                                        if(helptext==null)helptext=f.getLabel();
                                       }
           }
       }
       return helptext;
   }

   @AuraEnabled        
   public static boolean saveJobApplication(List<String> job) {
       system.debug('job>>'+job);
       
       Job_Application__c lstOfValues = new Job_Application__c(Name=job[0],Candidate_Profile__c=job[1],Job_Posting__c=job[2]);
       system.debug('Job_Application__c>>>'+lstOfValues);
       lstOfValues.Client_Approval_Process__c = 'Deloitte';
       lstOfValues.Profile_Status__c = 'Open';
       insert lstOfValues;
       
       List<Document_Master__c> docs = [select Id,Name,Job_Posting_Documents__c from Document_Master__c where Job_Posting_Documents__c =: job[2]];
       system.debug('docs>>'+docs);
       List<Job_Posting_Document__c> documentList = new  List<Job_Posting_Document__c>();
       if(docs != null){
           for(Document_Master__c doc : docs){
               Job_Posting_Document__c document = new Job_Posting_Document__c(Name = doc.Name,Document_Master__c=doc.Id,Job_Posting__c=job[2],Job_Application__c=lstOfValues.Id);
               documentList.add(document);
               system.debug('document>'+document);
           }
           insert documentList;
       }
       
       return true;
   }

   @AuraEnabled        
    public static List<Job_Posting__c> getJobPostingPickListValues(String clientId) {
        system.debug('clientId>>'+clientId);
        List <Job_Posting__c> lstOfValues = [Select Name from Job_Posting__c where Account__c =:clientId  LIMIT 10];
        system.debug('Job_Posting__c>>>'+lstOfValues);
        return lstOfValues;
    } 
    
    @AuraEnabled        
    public static List<Account> getClientPicklistValues() {
        List <Job_Posting__c> lstOfValues = [Select Account__r.Name from Job_Posting__c ];
        system.debug('Job_Posting__c>>>'+lstOfValues);
        Set<Id> accountSetId = new Set<Id>();
        for(Integer i =0; i<lstOfValues.size(); i++){
            accountSetId.add(lstOfValues[i].Account__c);
           
            system.debug('accountSetId>>>'+accountSetId);
        }
       List<Account> accountName = [Select Name from Account where Id IN : accountSetId];
       system.debug('accountName>>>'+accountName);
        return accountName;
    }   

    @AuraEnabled        
    public static Id getJobPostingValues(Id jobId, Id candSkills) {
        system.debug('jobId>>>'+jobId);
        system.debug('candSkills>>>'+candSkills);

        //Querying skills from job posting
        List <Skill_Set_Experience__c> lstOfValues = new  List <Skill_Set_Experience__c>();
        List <Job_Posting__c> pauseCheck = [select Id from Job_Posting__c where Id =: jobId AND Job_OC_Status__c <> 'Pause'];

        if(pauseCheck.size() <> 0){
        lstOfValues = [select Name,Skill_Experience_Level__c from Skill_Set_Experience__c where Job_Posting__c =: jobId];
        system.debug('Skill_Set_Experience__c>>>'+lstOfValues);
        }

        List<Skill_Set_Experience__c> candidateSkills = [Select Name,Skill_Experience_Level__c from Skill_Set_Experience__c where Candidate_Profile__c =: candSkills];
        system.debug('candidateSkills>>>'+candidateSkills);
        //Deserializing JSON Response
        //List<Skill_Set_Experience__c> deserializeSkill = (List<Skill_Set_Experience__c>) System.JSON.deserialize(candSkills, List<Skill_Set_Experience__c>.Class);
        
       // system.debug('deserializeSkill>>'+deserializeSkill);

        //Assigning jobposting skill values to Map
        Map<String,String> jobSkillsMap = new Map<String,String>();
        for(Skill_Set_Experience__c skillsName : lstOfValues){
            jobSkillsMap.put(skillsName.Name, skillsName.Skill_Experience_Level__c);
            system.debug('jobSkillsMap>>>'+jobSkillsMap);
        }
        Boolean skillsValues = false;

        //Comparing Candidate Skills and Job Posting Skills
        for(Skill_Set_Experience__c skillsCompare : candidateSkills){
            system.debug('skillsCompare>>'+skillsCompare);
            if(jobSkillsMap.containsKey(skillsCompare.Name) ){
                if(jobSkillsMap.get(skillsCompare.Name) == skillsCompare.Skill_Experience_Level__c){
                    skillsValues = true;
                }
                
            }

        }
        system.debug('skillsValues>>>'+skillsValues);
      
        return jobId;
       
        
   
    }

    //getting Resume Preview Link
    @AuraEnabled        
    public static Candidate_Profile__c getCandidateResume(String candId) {
        system.debug('candId>>>'+ candId);
        Candidate_Profile__c candProfile = [Select Name,Resume__r.PreviewLink__c from Candidate_Profile__c where Id =: candId];
        system.debug('candProfile>>>'+candProfile.Resume__r.PreviewLink__c);

        //String Id = GoogleDriveController.fileCreation(candProfile.Resume__r.Name, candProfile.Name);
        //System.debug('Id>>>'+Id);
        return candProfile;
    }
}