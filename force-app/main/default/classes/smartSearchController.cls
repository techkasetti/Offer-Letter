public class smartSearchController {
    
    @AuraEnabled        
    public static boolean getDepartmentPickListValues1(List<KTDO1__Skill_Set__c> skills) {
        system.debug('skills1>>>'+skills);
        for (KTDO1__Skill_Set__c fetch : skills){
            system.debug('skills>>>'+fetch.Name);
        }
        return true;
    } 
    
    @AuraEnabled        
    public static List<String> getDepartmentPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Skill_Set__c.KTDO1__Department__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getSkillSetPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Skill_Set__c.KTDO1__SkillSet_Experience__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    
    
    @AuraEnabled
    public static List<KTDO1__Candidate_Profile__c> getCustomerProfile(String curLocation,String expCTC,String minExperience,String maxExperience, String noticePer, List<KTDO1__Skill_Set__c> skills, List<KTDO1__Location_Set__c> preLocation){
        system.debug('curLocation>>>'+curLocation);
        system.debug('expCTC>>>'+expCTC);
        system.debug('minExperience>>>'+minExperience);
        system.debug('maxExperience>>>'+maxExperience);
        system.debug('noticePer>>>'+noticePer);
        system.debug('skills>>>'+skills);
        system.debug('preLocation>>>'+preLocation);
        
        String qryPbProDetails='select id,name,KTDO1__Current_Location__c,KTDO1__Expected_CTC__c, KTDO1__Experience__c, KTDO1__Notice_Period__c, KTDO1__Skills__c, KTDO1__Designation__c, KTDO1__Annual_CTC__c,  KTDO1__Preferred_Location__c, KTDO1__Gmail__c, KTDO1__Phone__c from KTDO1__Candidate_Profile__c'; 
        String qryPbProWhereClause=' where KTDO1__Notice_Period__c =\''+noticePer+'\'';
        
        //expectedCTC
        if(!String.isBlank(expCTC) && expCTC != ',')
        {
            List<String> lstexpCTC = expCTC.split(',');
            System.debug('lstexpCTC>>'+lstexpCTC);
            Decimal minExpCTC  = decimal.valueOf(lstexpCTC[0]);
            Decimal maxExpCTC  = decimal.valueOf(lstexpCTC[1]);
            System.debug('minExpCTC>>'+minExpCTC+'<<maxExpCTC>>'+maxExpCTC);
            
            qryPbProWhereClause+=' AND KTDO1__Expected_CTC__c >='+minExpCTC+' AND KTDO1__Expected_CTC__c <='+maxExpCTC;
        }
        
        //currentLocation
        if(!String.isBlank(curLocation))
        {
            qryPbProWhereClause+=' AND KTDO1__Current_Location__c <=\''+curLocation+'\'';
        }
        
        //experience
        if(!String.isBlank(minExperience) && !String.isBlank(maxExperience))
        {
            qryPbProWhereClause+=' AND KTDO1__Experience__c >='+minExperience+' AND KTDO1__Experience__c <='+maxExperience;
        }
        
        
        //skills
        if(skills != null) {
            for (KTDO1__Skill_Set__c fetch : skills){
                system.debug('skills>>>'+fetch.Name);
                qryPbProWhereClause+=' AND KTDO1__Skills__c =\''+fetch.Name+'\'';
            }
        } 
        
        //preferred Location
        if(preLocation != null) {
            for (KTDO1__Location_Set__c fetchLoc : preLocation){
                system.debug('preLocation>>>'+fetchLoc.Name);
                qryPbProWhereClause+=' AND KTDO1__Preferred_Location__c =\''+fetchLoc.Name+'\'';
            }
        } 
        
        
        qryPbProDetails=qryPbProDetails + qryPbProWhereClause;
        System.debug('qryPbProDetails>>'+qryPbProDetails);
        List<KTDO1__Candidate_Profile__c> listOfCandidates = (Database.query(qryPbProDetails));   
        return listOfCandidates;
        
    }
    
    /* @AuraEnabled
public static List<KTDO1__Job_Application__c> getProfile(){
List <KTDO1__Job_Application__c> lstOfValues = [Select Name,KTDO1__Annual_CTC__c,KTDO1__Experience__c,KTDO1__Current_Location__c,KTDO1__Designation__c,KTDO1__Status__c,KTDO1__Key_Skills__c,KTDO1__Profile_Status__c from KTDO1__Job_Application__c];
system.debug('KTDO1__Job_Application__c:'+lstOfValues);
return lstOfValues;
}
*/
    
    /* @AuraEnabled
public static List<KTDO1__Job_Application__c> getProfileCloned(){
List <KTDO1__Job_Application__c> lstOfValues = [Select Name,KTDO1__Annual_CTC__c,KTDO1__Experience__c,KTDO1__Current_Location__c,KTDO1__Designation__c,KTDO1__Status__c,KTDO1__Key_Skills__c,KTDO1__Profile_Status__c from KTDO1__Job_Application__c];
system.debug('KTDO1__Job_Application__c:'+lstOfValues);
Schema.sObjectField dependentField = KTDO1__Candidate_Profile__c.KTDO1__Status__c;
Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
//Get dependent field result
Schema.DescribeFieldResult dependentFieldResult = dependentField.getDescribe();
//Get dependent field controlling field 
Schema.sObjectField controllerField = dependentFieldResult.getController();
//Check controlling field is not null
if(controllerField == null){
// return null;
} 
//Get controlling field result
Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
//Get controlling field picklist values if controlling field is not a checkbox
List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());

//It is used to decode the characters of the validFor fields. 
String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
if (entry.isActive()){
//The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
for (Integer i = 0; i < controllerValues.size(); i++){
Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
Integer bitIndex = i / 6;
Integer bitShift = 5 - Math.mod(i, 6 );
if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
continue;
} 
if (!dependentPicklistValues.containsKey(controllerValue)){
dependentPicklistValues.put(controllerValue, new List<String>());
}
dependentPicklistValues.get(controllerValue).add(entry.getLabel());
}
}
}
system.debug('dependentPicklistValues ::'+dependentPicklistValues);
for(KTDO1__Job_Application__c values : lstOfValues){
String allstring = string.join(dependentPicklistValues.get(values.KTDO1__Profile_Status__c),',');
system.debug('dependentPicklistValues.get(values.KTDO1__Profile_Status__c)   :::'+dependentPicklistValues.get(values.KTDO1__Profile_Status__c).size());
if(dependentPicklistValues.get(values.KTDO1__Profile_Status__c)[0] != null){
values.KTDO1__Text_1__c = dependentPicklistValues.get(values.KTDO1__Profile_Status__c)[0];
}
if(dependentPicklistValues.get(values.KTDO1__Profile_Status__c).size() == 2){
values.KTDO1__Text_2__c = dependentPicklistValues.get(values.KTDO1__Profile_Status__c)[1];
}
}
system.debug('lstOfValues :::'+lstOfValues);
return lstOfValues;
}


@AuraEnabled
public static KTDO1__Job_Application__c updateprofileStatus( String buttonType, String buttonTypeId){
KTDO1__Job_Application__c lstOfValues = [Select Name,KTDO1__Annual_CTC__c,KTDO1__Experience__c,KTDO1__Current_Location__c,KTDO1__Designation__c,KTDO1__Status__c,KTDO1__Key_Skills__c,KTDO1__Profile_Status__c from KTDO1__Job_Application__c where Id =:buttonTypeId];
system.debug('KTDO1__Job_Application__c:'+lstOfValues);
lstOfValues.KTDO1__Profile_Status__c = buttonType;
update lstOfValues;
Schema.sObjectField dependentField = KTDO1__Candidate_Profile__c.KTDO1__Status__c;
Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
//Get dependent field result
Schema.DescribeFieldResult dependentFieldResult = dependentField.getDescribe();
//Get dependent field controlling field 
Schema.sObjectField controllerField = dependentFieldResult.getController();
//Check controlling field is not null
if(controllerField == null){
// return null;
} 
//Get controlling field result
Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
//Get controlling field picklist values if controlling field is not a checkbox
List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());

//It is used to decode the characters of the validFor fields. 
String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
if (entry.isActive()){
//The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
for (Integer i = 0; i < controllerValues.size(); i++){
Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
Integer bitIndex = i / 6;
Integer bitShift = 5 - Math.mod(i, 6 );
if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
continue;
} 
if (!dependentPicklistValues.containsKey(controllerValue)){
dependentPicklistValues.put(controllerValue, new List<String>());
}
dependentPicklistValues.get(controllerValue).add(entry.getLabel());
} 
}
}
system.debug('dependentPicklistValues ::'+dependentPicklistValues);
//for(KTDO1__Job_Application__c values : lstOfValues){
// String allstring = string.join(dependentPicklistValues.get(values.KTDO1__Profile_Status__c),',');
system.debug('dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c)   :::'+dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c).size());
if(dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c)[0] != null){
lstOfValues.KTDO1__Text_1__c = dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c)[0];
}
if(dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c).size() == 2){
lstOfValues.KTDO1__Text_2__c = dependentPicklistValues.get(lstOfValues.KTDO1__Profile_Status__c)[1];
}
//}
return lstOfValues;
}

@AuraEnabled
public static List<KTDO1__Job_Application__c> getProfileClonedwithId(String recId ){
List <KTDO1__Job_Application__c> lstOfValues = [Select Name,KTDO1__Annual_CTC__c,KTDO1__Experience__c,KTDO1__Current_Location__c,KTDO1__Designation__c,KTDO1__Status__c,KTDO1__Key_Skills__c,KTDO1__Profile_Status__c from KTDO1__Job_Application__c where id=:recId];
system.debug('KTDO1__Job_Application__c:'+lstOfValues);
Schema.sObjectField dependentField = KTDO1__Candidate_Profile__c.KTDO1__Status__c;
Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
//Get dependent field result
Schema.DescribeFieldResult dependentFieldResult = dependentField.getDescribe();
//Get dependent field controlling field 
Schema.sObjectField controllerField = dependentFieldResult.getController();
//Check controlling field is not null
if(controllerField == null){
// return null;
} 
//Get controlling field result
Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
//Get controlling field picklist values if controlling field is not a checkbox
List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());

//It is used to decode the characters of the validFor fields. 
String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
if (entry.isActive()){
//The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
for (Integer i = 0; i < controllerValues.size(); i++){
Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
Integer bitIndex = i / 6;
Integer bitShift = 5 - Math.mod(i, 6 );
if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
continue;
} 
if (!dependentPicklistValues.containsKey(controllerValue)){
dependentPicklistValues.put(controllerValue, new List<String>());
}
dependentPicklistValues.get(controllerValue).add(entry.getLabel());
}
}
}
system.debug('dependentPicklistValues ::'+dependentPicklistValues);
for(KTDO1__Job_Application__c values : lstOfValues){
String allstring = string.join(dependentPicklistValues.get(values.KTDO1__Profile_Status__c),',');

values.KTDO1__Key_Skills__c = allstring;
}
return lstOfValues;
}*/
    
    
    @AuraEnabled        
    public static List<String> getNoticePerPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Candidate_Profile__c.KTDO1__Notice_Period__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    //Method to fetch the Lookup Results of the Skills
    @AuraEnabled
    public static List<KTDO1__Skill_Set__c> fetchSkillsDataList(String enteredValue,String department) {
        
        String searchKey = enteredValue + '%';
        List <KTDO1__Skill_Set__c> lstOfValues = [Select Name,KTDO1__Department__c from KTDO1__Skill_Set__c where KTDO1__Department__c =: department AND Name like : searchKey LIMIT 10];
        system.debug('lstOfValues>>>'+lstOfValues);
        return lstOfValues;
    }
    
    //Method to fetch the Lookup Results of the Preferred Location
    @AuraEnabled
    public static List<Account> fetchPreLocationDataList(String enteredValue) {
        
        String searchKey = enteredValue + '%';
        List <Account> lstOfValues = [SELECT KTDO1__Billing_City__c FROM Account where KTDO1__Billing_City__c like : searchKey LIMIT 10];
        system.debug('Account>>>'+lstOfValues);
        return lstOfValues;
    } 
    
    //Method to fetch the Users list
    @AuraEnabled
    public static List<User> fetchUserDataList(String enteredValue) {
        
        String searchKey = enteredValue + '%';
        List <User> lstOfUser = [SELECT Name,UserName,user.Profile.Name FROM User WHERE IsActive = true AND user.Profile.Name <> null AND Name like : searchKey LIMIT 10];
        system.debug('lstOfUser>>>'+lstOfUser);
        return lstOfUser;
    }
    
    
    @AuraEnabled        
    public static List<String> getJoiningInPickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Job_Posting__c.KTDO1__Notice_Period__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    
    /*  @AuraEnabled
public static KTDO1__Job_Posting__c getCustomerProfile(String location,String expCTC,String minExperience,String maxExperience, String noticePer, String skills){
system.debug('curLocation>>>'+curLocation);
system.debug('expCTC>>>'+expCTC);
system.debug('minExperience>>>'+minExperience);
system.debug('maxExperience>>>'+maxExperience);
system.debug('noticePer>>>'+noticePer);
system.debug('skills>>>'+skills);

//    KTDO1__Job_Posting__c createNewRecord = [Select KTDO1__Client__c,KTDO1__Job_Heading__c,KTDO1__Designation__c,KTDO1__Skill_Set__c,KTDO1__No_Of_Positions__c,KTDO1__Min_Experience__c,KTDO1__Max_Experience__c,KTDO1__Location__c,KTDO1__Notice_Period__c,KTDO1__Min_CTC__c,KTDO1__Max_CTC__c from KTDO1__Job_Posting__c];
//   system.debug('KTDO1__Job_Application__c:'+lstOfValues);

//   return createNewRecord;

} */
    
    /*@AuraEnabled
public static void getStatus(String recId){

List <KTDO1__Job_Application__c> lstOfValues = [Select Id,Name,KTDO1__Annual_CTC__c,KTDO1__Experience__c,KTDO1__Current_Location__c,KTDO1__Designation__c,KTDO1__Status__c,KTDO1__Key_Skills__c,KTDO1__Profile_Status__c from KTDO1__Job_Application__c where Id=:recId ];
system.debug('KTDO1__Job_Application__c:'+lstOfValues);
KTDO1__Job_Application__c job =new KTDO1__Job_Application__c();
job.Id = recId;
job.KTDO1__Profile_Status__c='Lead Rejected';
system.debug('KTDO1__Profile_Status__c>>'+job.KTDO1__Profile_Status__c);
system.debug('lstOfValues>>'+lstOfValues);
update job;

}*/
    
    @AuraEnabled
    public static List<KTDO1__Skill_Set__c> fetchSkillsSetDataList(String enteredValue,String department,String skillSet) {
        
        String searchKey = enteredValue + '%';
        List <KTDO1__Skill_Set__c> lstOfValues = [Select Name,KTDO1__Department__c,KTDO1__SkillSet_Experience__c from KTDO1__Skill_Set__c where KTDO1__Department__c =: department AND Name like : searchKey LIMIT 10];
        system.debug('lstOfValues>>>'+lstOfValues);
        return lstOfValues;
    }
    
    
    @AuraEnabled
    public static List<KTDO1__Skill_Set_Experience__c> saveSkillAndExp(KTDO1__Candidate_Profile__c profile,String skillexp,String fileName,String base64Data,String contentType,String fileId,Map<String, Object> rollsAndRespMap)
    {
        system.debug('profile>>>'+profile);
        system.debug('skillexp>>>'+skillexp);
        system.debug('fileName>>>'+fileName);
        system.debug('base64Data>>>'+base64Data);
        system.debug('contentType>>>'+contentType);
        system.debug('fileId>>>'+fileId);
        system.debug('rollsAndRespMap>>>'+rollsAndRespMap);
        List<String> skillarray = (List<String>) System.JSON.deserialize(skillexp, String[].Class);
        system.debug(skillarray);
        
        insert profile;
        system.debug('Profile>>>'+profile.Id);
        system.debug('Location>>>'+Profile.KTDO1__Preferred_Location__c);
        system.debug('fileName>>>'+fileName);
        List<KTDO1__Skill_Set_Experience__c> skillList = new  List<KTDO1__Skill_Set_Experience__c>();
        
        for(Integer i=0; i<skillarray.size(); i+=4){
            system.debug('ProfileInsertedId'+profile.Id+':'+skillarray[i]+skillarray[i+1]+skillarray[i+2]);
            KTDO1__Skill_Set_Experience__c skillAndExp = new KTDO1__Skill_Set_Experience__c(KTDO1__Candidate_Profile__c=profile.Id, 
                                                                                            Name=skillarray[i],
                                                                                            KTDO1__Skill_Set__c=skillarray[i+1],
                                                                                            KTDO1__SkillSet_Experience__c=skillarray[i+2],
                                                                                            KTDO1__Ratings__c=skillarray[i+3]
                                                                                           );
            skillList.add(skillAndExp);
            system.debug('skillAndExp>'+skillAndExp);
        } 
        
        insert skillList;
        system.debug('skillList>'+skillList[0].KTDO1__Candidate_Profile__c);
        
        
        
        
        List<KTDO1__Roll_and_Responsibilities__c> rollsAndRespList = new List<KTDO1__Roll_and_Responsibilities__c>();
        
        
        for(String var : rollsAndRespMap.keySet())
        {
            
            KTDO1__Roll_and_Responsibilities__c newObj = new KTDO1__Roll_and_Responsibilities__c();
            System.debug('>>>>'+JSON.serialize(rollsAndRespMap.get(var)));
            String value = JSON.serialize(rollsAndRespMap.get(var));
            Map<String, String> m = (Map<String, String>)JSON.deserialize(value, Map<String, String>.class);
            
            KTDO1__Roll_and_Responsibilities__c candP = new KTDO1__Roll_and_Responsibilities__c();
            candP.Name =m.get('Name');
            candP.KTDO1__Candidate_Profile__c = profile.ID;
            candP.KTDO1__Type__c = m.get('KTDO1__Type__c');
            
            
            
            rollsAndRespList.add(candP);
            system.debug('rollsAndRespMap.get(var)>>'+rollsAndRespMap.get(var));
            /* KTDO1__Roll_and_Responsibilities__c newRec = new KTDO1__Roll_and_Responsibilities__c();
newRec.Name = (rollsAndRespMap.get(var));
newRec.KTDO1__Type__c =rollsAndRespMap.get(var).KTDO1__Type__c;
newRec.KTDO1__Candidate_Profile__c = rollsAndRespMap.get(var).Id;*/
        }
        insert rollsAndRespList;
        
        
        
        //To Upload Document to Record
        if (fileId == '') {
            system.debug('skillList>'+skillList[0].KTDO1__Candidate_Profile__c);
            
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = fileName; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
            insert conVer;
            
            // First get the content document Id from ContentVersion
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : conVer.Id].ContentDocumentId;
            
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = skillList[0].KTDO1__Candidate_Profile__c; // you can use objectId,GroupId,ParentId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            cDe.Visibility = 'InternalUsers';
            insert cDe;
            
            
        }
        
        return skillList;
    } 
    
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = : fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
    @AuraEnabled
    
    public static List<ContentDocumentLink> fetchDocument (Id parentID)
    {
        String imageURL='';
        system.debug('ID ::'+parentID);
        
        
        List<ContentDocumentLink> attList = [SELECT ContentDocumentId  FROM ContentDocumentLink  
                                             WHERE LinkedEntityId  =:parentID ];  
        system.debug('attList ::'+attList);
        //    if(attList.size() > 0){
        //         imageURL='/servlet/servlet.FileDownload?file='+attList[0].id;
        //      system.debug('imageURL ::'+imageURL);
        //    }
        
        return attList;
    }
    
    @AuraEnabled
    public static List<KTDO1__Candidate_Profile__c> fetchCandidateDataList(String enteredValue) {
        
        String searchKey = enteredValue + '%';
        List <KTDO1__Candidate_Profile__c> lstOfValues = [Select Name from KTDO1__Candidate_Profile__c where Name like : searchKey LIMIT 10];
        system.debug('KTDO1__Candidate_Profile__c>>>'+lstOfValues);
        return lstOfValues;
    }
    
    @AuraEnabled        
    public static List<String> getIndustryPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Candidate_Profile__c.KTDO1__Industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getFunctionalAreaPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Candidate_Profile__c.KTDO1__Functional_Area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getDesignationPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Candidate_Profile__c.KTDO1__Designation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getStreamPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Candidate_Profile__c.KTDO1__UG_Stream__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<String> getPGStreamPicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Candidate_Profile__c.KTDO1__PG_Stream__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<KTDO1__Candidate_Profile__c> getCandidateProfile(List<String> skillexp, boolean buttonSelected) {
        system.debug('skillexp>>>'+skillexp);
        system.debug('SelectedButton>>>'+buttonSelected);
        String qryPbProDetails='select name,KTDO1__SkillSet_Experience__c,KTDO1__Candidate_Profile__c, KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.Name, KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Email__c, KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Phone__c, KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Current_Location__c,KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Designation__c,KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Employers__c,KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Annual_CTC__c,KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Expected_CTC__c,KTDO1__Skill_Set_Experience__c.KTDO1__Candidate_Profile__r.KTDO1__Preferred_Location__c from KTDO1__Skill_Set_Experience__c where '; 
        
        String qryPbProWhereClause = ' ' ;
        system.debug('qryPbProDetails'+qryPbProDetails);
        
        for(Integer i=0; i<skillexp.size(); i+=2){
            system.debug('Skill>>'+skillexp[i]+skillexp[i+1]);
            qryPbProWhereClause+=' (Name =\''+skillexp[i]+'\'';
            qryPbProWhereClause+=' AND KTDO1__SkillSet_Experience__c =\''+skillexp[i+1]+'\')';
            system.debug('qryPbProWhereClause'+qryPbProWhereClause);
        }
        if(buttonSelected==true){
            system.debug('Inside');
            qryPbProWhereClause+=' AND LastModifiedDate = LAST_N_DAYS:15 ';
            system.debug('qryPbProWhereClause>>'+qryPbProWhereClause);
        }
        
        qryPbProDetails = qryPbProDetails+ qryPbProWhereClause ;
        system.debug('qryPbProDetails'+qryPbProDetails);
        
        List<KTDO1__Skill_Set_Experience__c> listOfCandidates = (Database.query(qryPbProDetails));  
        
        System.debug('listOfCandidates'+listOfCandidates);
        
        //For filtering Duplicate Candidate id's
        Set<String> skills = new Set<String>();
        for(Integer i =0;i<listOfCandidates.size();i++){
            //System.debug('listOfCandidates'+listOfCandidates[i].KTDO1__Candidate_Profile__c);
            if(listOfCandidates[i].KTDO1__Candidate_Profile__c!= null){
                if(skills.contains(listOfCandidates[i].KTDO1__Candidate_Profile__c)){
                    System.debug('Inside');
                }else{
                    skills.add(listOfCandidates[i].KTDO1__Candidate_Profile__c);
                    
                }
            } 
        }
        
        List<KTDO1__Candidate_Profile__c> candProfile = [select Name,KTDO1__Email__c,KTDO1__Phone__c,KTDO1__Current_Location__c,KTDO1__Designation__c,KTDO1__Employers__c,KTDO1__Expected_CTC__c,KTDO1__Annual_CTC__c,KTDO1__Preferred_Location__c,(select Name,KTDO1__SkillSet_Experience__c from KTDO1__Skill_Set_Experiences__r) from KTDO1__Candidate_Profile__c where Id  IN : skills];
        
        system.debug('candProfile>'+candProfile);
        
        
        
        return candProfile;
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
    public static List<String> getsObjects(){
        List<String> sObjectList = new List<String>();
        FOR(Schema.SObjectType sObj : Schema.getGlobalDescribe().values()){
            // Show only those objects which have atleast one Field Set
            Map<String, Schema.FieldSet> FieldSetMap = sObj.getDescribe().fieldSets.getMap();
            if(FieldSetMap!=null && FieldSetMap.keySet().size() > 0){
                sObjectList.add(sObj.getDescribe().getName() +'####'+sObj.getDescribe().getLabel());
            }
        }
        return sObjectList;
    }
    
    @AuraEnabled 
    public static List<String> getFieldSet(String sObjectName){
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjectName);
        List<String> fieldSetList = new List<String>();
        FOR(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values()){
            fieldSetList.add(fs.getName() +'####'+fs.getLabel());
        }
        return fieldSetList;
    }
    
    @AuraEnabled //@future
    public static String getFieldSetMember(String objectName , String fieldSetName){
        
        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
        
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
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
        return JSON.serialize(wrapperList);
    }
    
    @AuraEnabled
    public static String doUpsertObjects(sObject objectData){
        upsert objectData;
        return JSON.serialize(objectData);
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
    public static List<KTDO1__Job_Posting__c> getJobPostingPickListValues(String clientId) {
        system.debug('clientId>>'+clientId);
        List <KTDO1__Job_Posting__c> lstOfValues = [Select Name from KTDO1__Job_Posting__c where KTDO1__Account__c =:clientId  LIMIT 10];
        system.debug('KTDO1__Job_Posting__c>>>'+lstOfValues);
        return lstOfValues;
    }    
    
    @AuraEnabled        
    public static boolean saveJobApplication(List<String> job) {
        system.debug('job>>'+job);
        
        KTDO1__Job_Application__c lstOfValues = new KTDO1__Job_Application__c(Name=job[0],KTDO1__Candidate_Profile__c=job[1],KTDO1__Job_Posting__c=job[2]);
        system.debug('KTDO1__Job_Application__c>>>'+lstOfValues);
       // lstOfValues.Client_Approval_Process = 'Deloitte';
        insert lstOfValues;
        
        List<KTDO1__Document_Master__c> docs = [select Id,Name,KTDO1__Job_Posting_Documents__c from KTDO1__Document_Master__c where KTDO1__Job_Posting_Documents__c =: job[2]];
        system.debug('docs>>'+docs);
        List<KTDO1__Job_Posting_Document__c> documentList = new  List<KTDO1__Job_Posting_Document__c>();
        if(docs != null){
            for(KTDO1__Document_Master__c doc : docs){
                KTDO1__Job_Posting_Document__c document = new KTDO1__Job_Posting_Document__c(Name = doc.Name, 
                                                                                             KTDO1__Document_Master__c=doc.Id,
                                                                                             KTDO1__Job_Posting__c=job[2],
                                                                                             KTDO1__Job_Application__c=lstOfValues.Id
                                                                                            );
                documentList.add(document);
                system.debug('document>'+document);
            }
            insert documentList;
        }
        
        return true;
    }  
    
    @AuraEnabled
    public static void postingJob(String client,String designation,Integer noOfPositions,String location,String skillexp,double minCTC,double maxCTC,String documents,Date dueDate,List<String> userIds){
        system.debug('client>>>'+client);
        system.debug('designation>>>'+designation);
        system.debug('noOfPositions>>>'+noOfPositions);
        system.debug('location>>>'+location);
        system.debug('skillexp>>>'+skillexp);
        system.debug('minCTC>>>'+minCTC);
        system.debug('maxCTC>>>'+maxCTC); 
        system.debug('documents>>>'+documents);  
        System.debug('dueDate>>'+dueDate);
        
        KTDO1__Job_Posting__c obj = new KTDO1__Job_Posting__c();
        obj.Name = client;
        obj.KTDO1__Designation__c = designation;
        obj.KTDO1__No_Of_Positions__c = noOfPositions;
        obj.KTDO1__Location__c = location;
        obj.KTDO1__Contact__c ='0034x000004g0OEAAY';
        obj.KTDO1__Teams__c = 'a2T4x000000ZPhpEAG';
        obj.KTDO1__Min_CTC__c = minCTC;
        obj.KTDO1__Max_CTC__c = maxCTC;
        obj.KTDO1__Posting_Due_Date__c = dueDate;
        obj.KTDO1__No_Of_Candidate_Selected__c = 0;
        obj.KTDO1__Job_OC_Status__c = 'Open';
        insert obj;
        
        //skillset insert into child object
        String[] skillarray = (String[]) System.JSON.deserialize(skillexp, String[].Class);
        system.debug(skillarray);
        
        List<KTDO1__Skill_Set_Experience__c> skillList = new  List<KTDO1__Skill_Set_Experience__c>();    
        for(Integer i=0; i<skillarray.size(); i+=3){
            system.debug('jobPostingProfileId>>'+obj.Id+'<<<<:>>>>>'+skillarray[i]+skillarray[i+1]+skillarray[i+2]);
            KTDO1__Skill_Set_Experience__c jobPostingProfile = new KTDO1__Skill_Set_Experience__c(KTDO1__Job_Posting__c = obj.Id, 
                                                                                                  Name=skillarray[i],
                                                                                                  KTDO1__Skill_Set__c=skillarray[i+1],
                                                                                                  KTDO1__SkillSet_Experience__c=skillarray[i+2]
                                                                                                 );
            skillList.add(jobPostingProfile);
            system.debug('jobPostingProfile>'+jobPostingProfile);
            system.debug('skillList>'+skillList);
        }
        insert skillList;
        
        //jobPostingDocuments insert into child object
        //String[] documentarray = (String[]) System.JSON.deserialize(documents, String[].Class);
        List<String> documentarray = documents.split(',');
        system.debug(documentarray);
        
        List<KTDO1__Document_Master__c> documentList = new  List<KTDO1__Document_Master__c>();    
        for(Integer i=0; i<documentarray.size(); i++){
            system.debug('jobPostingProfileId>>'+obj.Id+'<<<<:>>>>>'+documentarray[i]);
            KTDO1__Document_Master__c document = new KTDO1__Document_Master__c(KTDO1__Job_Posting_Documents__c = obj.Id, 
                                                                               Name=documentarray[i] 
                                                                              );
            documentList.add(document);
            system.debug('document>'+document);
        }
        system.debug('documentList>'+documentList);
        insert documentList;
        
    }
    
    @AuraEnabled        
    public static List<CustomTeams__Teams__c> getTeams() {
        List <CustomTeams__Teams__c> lstOfTeam = [select Name from CustomTeams__Teams__c];
        system.debug('CustomTeams__Teams__c>>>'+lstOfTeam);
        return lstOfTeam;
    }
    
    @AuraEnabled        
    public static List<CustomTeams__Team_Members__c> getTeamMembers(String team) {
        system.debug('team>>>'+team);
        List <CustomTeams__Team_Members__c> lstOfTeamMembers = [Select CustomTeams__User__r.Name from CustomTeams__Team_Members__c where CustomTeams__Team__r.Name =: team];
        system.debug('CustomTeams__Team_Members__c>>>'+lstOfTeamMembers);
        return lstOfTeamMembers;
    }
    
    @AuraEnabled        
    public static List<String> getSkillSetRatingPickList() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Skill_Set_Experience__c.KTDO1__Ratings__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled        
    public static List<KTDO1__Skill_Set_Experience__c> getJobPostingValues(Id jobId, String candSkills) {
        system.debug('jobId>>>'+jobId);
        system.debug('candSkills>>>'+candSkills);
        List <KTDO1__Skill_Set_Experience__c> lstOfValues = [select Name,KTDO1__SkillSet_Experience__c from KTDO1__Skill_Set_Experience__c where KTDO1__Job_Posting__c =: jobId];
        system.debug('KTDO1__Skill_Set_Experience__c>>>'+lstOfValues);
        return lstOfValues;
    }
    
    @AuraEnabled        
    public static List<Account> getClientPicklistValues() {
        List <Account> lstOfValues = [Select Name from Account ];
        system.debug('Account>>>'+lstOfValues);
        return lstOfValues;
    }    
    
    @AuraEnabled        
    public static List<String> getTypePicklistValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Rolls_and_Responsibilities_Master__c.KTDO1__Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Type values are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    //Method to fetch the Lookup Results of the Rolls and Responsibilities
    @AuraEnabled
    public static List<KTDO1__Rolls_and_Responsibilities_Master__c> fetchRollsResponsibilitiesList(String enteredValue,String type) {
        String searchKey = enteredValue + '%';
        List <KTDO1__Rolls_and_Responsibilities_Master__c> lstOfValues = [Select Name,KTDO1__Type__c from KTDO1__Rolls_and_Responsibilities_Master__c where KTDO1__Type__c =: type AND Name like : searchKey LIMIT 10];
        system.debug('lstOfValues>>>'+lstOfValues);
        return lstOfValues;
    }

    @AuraEnabled        
    public static List<String> getJobTypePickListValues() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = KTDO1__Job_Posting__c.KTDO1__Job_Requirement_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }


}