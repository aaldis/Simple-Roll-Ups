public with sharing class RollUpSummaryHelper {
    
    
    public static void rollUp(String metaDataType, List<sObject> objectList) {
        RollUpSummaries__mdt rollUp = RollUpSummaries__mdt.getInstance(metaDataType);
        String action = rollUp.Action__c;
        String resultField = rollUp.Aggregate_Result_Field__c;
        String childObject = rollUp.ChildObject__c;
        String lookUpField = rollUp.Look_Up_Field__c;
        String parentObject = rollUp.Parent_Object__c;
        Boolean Unique = rollUp.Unique__c;
        String uniqueField = rollUp.Unique_Field__c;
        String whereClause = rollUp.Where_Clause__c;
        map<String, list<string>> idMap = getIdList(objectList, lookUpField);
        list<string> idQueryList = idMap.get('idQueryList');
        list<string> idList = idMap.get('idList');
        list<sObject> listToUpdate = new List<sObject>();
        String selectStatement = 'Select Id, '+lookUpField;
       String fromStatement = ' From '+childObject;
        String whereStatement = whereClause == null?' Where '+lookUpField+' in '+idQueryList: ' Where '+lookUpField+' in '+idQueryList+' And '+whereClause;
        String childQuery = selectStatement+fromStatement+whereStatement;
        String parentQuery = 'select id, '+resultField +' from '+parentObject+' where id in '+idQueryList;      
        List<sObject> childObjectList = database.query(childQuery);
        List<sObject> parentObjectList = database.query(parentQuery);
        if(unique){
            childObjectList = returnUnique(childObjectList, uniqueField);
        }
        map<String, Integer> countMap = returnCount(idList, childObjectList, lookUpField);
        for(string s: idList){
            
        }
        List<Database.SaveResult> result = processRecords(parentObjectList, countMap, lookUpField, resultField);        
    }

   public static map<String, list<string>> getIdList(List<sObject> objectList, String lookUpField){
    map<String, list<string>> idMap = new map<String, list<string>>();
    list<string> idQueryList = new list<string>();
    list<string> idList = new list<string>();
       for(integer i = 0; i < objectList.size(); i++){
        idQueryList.add('\''+objectList[i].get(lookUpField)+'\'');
        idList.add(string.valueOf(objectList[i].get(lookUpField)));
       }
       idMap.put('idQueryList', idQueryList);
       idMap.put('idList', idList);
       return idMap;
   }

   public static map<String, Integer> returnCount(List<String> idList, List<sObject> childObjectList, String lookUpField){
    map<String, Integer> countMap = new map<String, Integer>();
    
    for(String s:idList){
        List<string> dummyList = new List<String>();
           for(sObject ul: childObjectList){
            string listId = string.valueof(ul.get(lookUpField));
                if(s == listId){
                    dummyList.add(listId);
                }
           }
           countMap.put(s, dummyList.Size());
       }
       return countMap;
   }

   public static list<sObject> returnUnique(List<sObject> childObjectList, string uniqueField){
    list<sObject> uniqueList = new list<sObject>();
       return null;
   }

   public static  List<Database.SaveResult> processRecords(List<sObject> parentObjectList, Map<String,Integer> countMap, String lookUpField, String resultField){
    
    for(sObject s1: parentObjectList){
        String parentId = String.valueof(s1.get('id'));
        s1.put(resultField, countMap.get(parentId));
    }
    List<Database.SaveResult> result = database.update(parentObjectList, false);
    return result;
   }
   

}