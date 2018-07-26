trigger packingInTrigger on ConfigurationList__c (after insert,after update) {
Set <Id>aId = new Set<Id>(); 

for(ConfigurationList__c e : Trigger.New){ 
aId.add(e.Opportuniy__c); 
} 
List<Opportunity> acc = [select id,Name,DXConNum__c from Opportunity where Id in:aId]; 
List<ConfigurationList__c> con = [select id,RecordType.Name,Opportuniy__c from ConfigurationList__c where Opportuniy__c = :aId];
List<ConfigurationList__c> con1= new List<ConfigurationList__c>();    
System.debug('=========con.size: '+ con.size() );
for(Opportunity a : acc){
for(Integer i=0;i<con.size();i++){
if(con.size()>0 && con.get(i).RecordType.Name=='配置单-大型'){
con1.add(con.get(i));
}
a.DXConNum__c=con1.size();
}
}    
update acc; 
}
