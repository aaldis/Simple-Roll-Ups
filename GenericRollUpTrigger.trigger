trigger GenericRollUpTrigger on SOBJECT_HERE (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if (trigger.isAfter) {
        List<SOBJECT_HERE> triggerList = new List<SOBJECT_HERE>();
        if(trigger.isDelete){
            triggerList = trigger.old;
        }
        if(trigger.isInsert || trigger.isUpdate ){
            triggerList = trigger.new;
        }
            List<SOBJECT_HERE> list1 = new List<SOBJECT_HERE>();
            List<SOBJECT_HERE> list2 = new List<SOBJECT_HERE>();
            for(SOBJECT_HERE so: triggerList){
                if(so.Program__c != null){
                    list1.add(so);
                } 
                if(so.Lesson__c != null){
                    list2.add(so);
                }
            }
            if(list1.size() >0){
                RollUpSummaryHelper.rollUp('Program_Number_of_Instructors', list1);
            }
            if(list2.size() >0){
                RollUpSummaryHelper.rollUp('Lesson_Number_of_Instructors', list2);
            }
        }				
    }
