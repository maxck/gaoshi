trigger OppAmountTrigger on Opportunity (before insert ,before update) {
    
    Set<Id> setId  =new Set<Id>();
    Decimal totalAmount = 0 ;
    //Decimal KNX  =  0 ;
    for(Opportunity newOpp : trigger.new){
        setId.add(newOpp.Id);
        //KNX = newOpp.Probability ; 
        
    }
    
    Map<Id,List<CustomObject18__c>>  cusMap  =  new  Map<Id,List<CustomObject18__c >>();
    for(CustomObject18__c  Cus: [select TotalMoney__c,Field1__c   from CustomObject18__c where  Field1__c= : setId]){
        if(CusMap.containskey(Cus.Field1__c )){
            List<CustomObject18__c> tempCus = cusMap.get(Cus.Field1__c);
            tempCus.add(Cus);
            cusMap .put(Cus.Field1__c, tempCus);
        }
        else
        {
            cusMap.put(Cus.Field1__c, new List<CustomObject18__c>{Cus});    
        }    
    }
    for(Opportunity newOpp : trigger.new){
        
        if (cusMap.containsKey(newOpp.id))
        {
             List<CustomObject18__c>  cusList  =  cusMap.get(newOpp.id); 
             if(cusList.size()> 0){
                 for(Integer i =0 ; i < cusList.size() ; i++){
                 totalAmount = totalAmount + cusList.get(i).TotalMoney__c;
            }
            //newOpp.Amount = totalAmount * KNX /100  ; 
            newOpp.Amount = totalAmount ; 
            } 
          } 
      } 
    }
