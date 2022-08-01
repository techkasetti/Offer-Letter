Public class CandFieldSet {
    
    /* @AuraEnabled 
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
String dha = 'KTDO1__'+fieldSetName;
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
}*/
    
    @AuraEnabled 
    public static String getFieldSetMemberClone(String fieldSetName){
        system.debug('fieldSetName >>>>'+fieldSetName);
        // String spliteVals = fieldSetName[0];
        // system.debug('spliteVals ::::::'+spliteVals);
        String objectName =  'KTDO1__Candidate_Profile__c'; 
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
            String dha = 'KTDO1__'+strList;
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
    
    /*@AuraEnabled
public static  List<KTDO1__Candidate_Profile__c> doUpsertObjects(String objectData , List<String> skillList){
system.debug('skillList >>>>>>>>>'+skillList); 
Candidate_Profile__c caseObj = (Candidate_Profile__c)JSON.deserialize(objectData,Candidate_Profile__c.class);
sObject contactsForUpdate = (sObject) JSON.deserialize(
objectData,
Type.forName('KTDO1__Candidate_Profile__c'));
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
List<KTDO1__Skill_Set_Experience__c > skillsetExp = [Select Id , Name ,KTDO1__Candidate_Profile__c From KTDO1__Skill_Set_Experience__c where Name IN:skillList];
system.debug('skillsetExp >>>>>>>>>'+skillsetExp);
Set<String> candIds = new Set<String>();

for(KTDO1__Skill_Set_Experience__c listIds : skillsetExp){
if(listIds.KTDO1__Candidate_Profile__c != null){
candIds.add('\''+listIds.KTDO1__Candidate_Profile__c+'\'');    
//candIds.add(listIds.KTDO1__Candidate_Profile__c);    
}
}
List<String> listStrings = new List<String>();
listStrings.addAll(candIds);
system.debug('listStrings  ::::::'+listStrings);
// upsert objectData;
String searchquery;
searchquery = 'SELECT Id , Name , KTDO1__Designation__c,KTDO1__Expected_CTC__c , KTDO1__Notice_Period__c From KTDO1__Candidate_Profile__c Where KTDO1__Notice_Period__c ='+ '\''+ caseObj.KTDO1__Notice_Period__c + '\' AND  KTDO1__Designation__c ='+ '\''+ caseObj.KTDO1__Designation__c + '\'';
if(listStrings.size()>0){
searchquery +=' AND Id IN '+listStrings;
}

system.debug('searchquery >>>>>>>>>'+searchquery);
List<KTDO1__Candidate_Profile__c> records = Database.query(searchquery);
system.debug('records >>>>>>>>>'+records);
return records;
}

@AuraEnabled
public static List<String> getSkillSets(String selectedDeparment){
List<KTDO1__Skill_Set__c> skillSets = [Select id , Name From KTDO1__Skill_Set__c where KTDO1__Department__c =: selectedDeparment ];
system.debug('skillSets >>>>>>'+skillSets);
List<String> listVals = new List<String>();
for(KTDO1__Skill_Set__c individualskill :skillSets ){
listVals.add(individualskill.Name);
}
system.debug('listVals   >>>>'+listVals);
return listVals;

}

@AuraEnabled
public static List<String> getSkillSetsDepartment(){
List<String> listVals = new List<String>();
Schema.DescribeFieldResult fieldResult = KTDO1__Skill_Set__c.KTDO1__Department__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
for( Schema.PicklistEntry pickListVal : ple){
listVals.add(pickListVal.getLabel());
}
system.debug('listVals   >>>>'+listVals);
return listVals;

}*/    
    @AuraEnabled
    public static  List<KTDO1__Candidate_Profile__c> searchProfiles(String parentobjectData ,List<KTDO1__Skill_Set_Experience__c> objectData){
        system.debug('parentobjectData >>>>>>>>>'+parentobjectData); 
        Candidate_Profile__c caseObj = (Candidate_Profile__c)JSON.deserialize(parentobjectData,Candidate_Profile__c.class);
        system.debug('caseObj    >>>>>'+caseObj);
        system.debug('objectData >>>>>>>>>'+objectData); 
        set<String> candidateIds = new set<String>();
        set<String> finalcandidateIds = new set<String>();
        List<String> lst =new List<String>();
        List<String> candidatelst =new List<String>();
        string conditionstr;
        // for(KTDO1__Skill_Set_Experience__c skillsetlst : objectData){
        for(Integer i=0 ; i< objectData.size() ;i++){
            system.debug('i >>>>>'+i);
            conditionstr = 'SELECT id , KTDO1__Candidate_Profile__c FROM KTDO1__Skill_Set_Experience__c WHERE ' ;
            if(candidateIds.size()==0){
                conditionstr += ' ('+ 'KTDO1__Skill_Set__c = ' +  '\'' + objectData[i].KTDO1__Skill_Set__c + '\'' +' AND KTDO1__Ratings__c = ' +  '\'' +  objectData[i].KTDO1__Ratings__c + '\'' + ' AND KTDO1__Skill_Experience_Level__c  >= '+  '\'' +  objectData[i].KTDO1__Min_Experiance__c + '\'' +' AND KTDO1__Skill_Experience_Level__c  <=' + '\'' +  objectData[i].KTDO1__Max_Experiance__c  + '\'' +') ';
                system.debug('conditionstr   :::::'+conditionstr);
            }
            else{
                conditionstr += ' ('+ 'KTDO1__Skill_Set__c = ' +  '\'' +  objectData[i].KTDO1__Skill_Set__c + '\'' +' AND KTDO1__Ratings__c = ' +  '\'' +  objectData[i].KTDO1__Ratings__c + '\'' + ' AND KTDO1__Skill_Experience_Level__c  >= '+  '\'' +  objectData[i].KTDO1__Min_Experiance__c + '\'' +' AND KTDO1__Skill_Experience_Level__c  <=' + '\'' +  objectData[i].KTDO1__Max_Experiance__c  + '\'' +') '+ ' AND KTDO1__Candidate_Profile__c  IN '+lst;
                system.debug('conditionstr   :::::'+conditionstr);
            }
            List<KTDO1__Skill_Set_Experience__c> records = Database.query(conditionstr);
            system.debug('records    :::::'+records);
            candidateIds.clear();
            lst.clear();
            for(KTDO1__Skill_Set_Experience__c lststr :records){
                if(i == objectData.size()-1 ){
                    finalcandidateIds.add('\'' +lststr.KTDO1__Candidate_Profile__c + '\'');
                }else{
                    candidateIds.add('\'' +lststr.KTDO1__Candidate_Profile__c + '\'');     
                }
            }
            system.debug('candidateIds   >>>> '+candidateIds);
            lst.addAll(candidateIds);
            system.debug('lst   >>>>'+lst);
            candidatelst.addAll(finalcandidateIds);
        }
        
        String searchquery;
        searchquery = 'SELECT Id , Name , KTDO1__Designation__c,KTDO1__Expected_CTC__c , KTDO1__Notice_Period__c From KTDO1__Candidate_Profile__c Where KTDO1__Notice_Period__c ='+ '\''+ caseObj.KTDO1__Notice_Period__c + '\'';
        if(caseObj.KTDO1__Designation__c != Null){
            searchquery +=   'AND  KTDO1__Designation__c ='+ '\''+ caseObj.KTDO1__Designation__c + '\'';
        }
        if(caseObj.KTDO1__Email__c != Null){
            searchquery +=  ' AND  KTDO1__Email__c ='+ '\''+ caseObj.KTDO1__Email__c + '\'';
        }
        if(caseObj.KTDO1__Phone__c != Null){
            searchquery +=  ' AND  KTDO1__Phone__c ='+ '\''+ caseObj.KTDO1__Phone__c + '\'';
        }
        if(candidatelst.size() >0){
            searchquery +=  'AND id IN '+candidatelst ;
        }
        system.debug('searchquery >>>>>>>>>'+searchquery);
        List<KTDO1__Candidate_Profile__c> profileRecords = Database.query(searchquery);
        //system.debug('records >>>>>>>>>'+records);
        // List<KTDO1__Candidate_Profile__c> profileRecords = [SELECT Id , Name , KTDO1__Designation__c,KTDO1__Expected_CTC__c , KTDO1__Notice_Period__c From KTDO1__Candidate_Profile__c Where id IN:finalcandidateIds];
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
    
    
    
    
    /*@AuraEnabled
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
}*/
}