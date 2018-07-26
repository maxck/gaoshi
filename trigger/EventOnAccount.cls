trigger EventOnAccount on Event (after insert, after delete,after undelete,after update) { 
Set <Id>aId = new Set<Id>(); 
if(Trigger.isInsert || Trigger.isUndelete){ 
for(Event e : Trigger.New){ 
aId.add(e.AccountName__c); 
} 
List<Account> acc = [select id,SalesActivityDivision__c from Account where Id in:aId]; 
List<Event> con = [select AccountName__c from Event where AccountName__c = :aId]; 

System.debug('=========con.size: '+ con.size() );
for(Account a : acc){ 
//a.TestNumber__c=con.size(); 
if(con.size()>0){
a.SalesActivityDivision__c='有销售活动';
}else{
a.SalesActivityDivision__c='无销售活动';
}
}
update acc; 
} 
if(Trigger.isDelete){ 
for(Event e : Trigger.old){ 
aId.add(e.AccountName__c); 
} 
List<Account>  acc = [select id,TestNumber__c,SalesActivityDivision__c from Account where Id in:aId];
List<Event>  con = [select AccountName__c from Event where AccountName__c = :aId]; 

System.debug('=========con.size: '+ con.size() );
for(Account a : acc){ 

//a.TestNumber__c=con.size(); 
if(con.size()>0){
a.SalesActivityDivision__c='有销售活动';
}else{
a.SalesActivityDivision__c='无销售活动';
}
}
update acc; 
} 
if(Trigger.isUpdate){
Set <Id>OldAId = new Set<Id>(); 
for(Event e : Trigger.new){ 

if(e.AccountName__c != Trigger.oldMap.get(e.id).AccountName__c ) 
aId.add(e.AccountName__c); 
system.debug('aId :'+ aId);
OldAId.add(Trigger.oldMap.get(e.id).AccountName__c); 
} 
if(!aId.isEmpty()){ 
//for new Accounts 
List <Account> acc = [select id,TestNumber__c,SalesActivityDivision__c from Account where Id in:aId]; 
//For New Account Contacts
List<Event>  con = [select AccountName__c from Event where AccountName__c = :aId]; 

/* This is For Old Contacts Count */ 
//for Old Accounts 
List<Account>  Oldacc = [select id,TestNumber__c,SalesActivityDivision__c from Account where Id in:OldAId]; 
//For Old Account Contacts 
List <Event> OldCon = [select AccountName__c from Event where AccountName__c = :OldAId]; 

//For New Accounts 
System.debug('=========con.size: '+ con.size() );
for(Account a : acc){ 
//a.TestNumber__c=con.size(); 
if(con.size()>0){
a.SalesActivityDivision__c='有销售活动';
}else{
a.SalesActivityDivision__c='无销售活动';
}
}
update acc; 
//For Old Accounts 
System.debug('=========oldcon.size: '+ OldCon.size() );
for(Account a : Oldacc) {
//a.TestNumber__c=OldCon.size(); 
if(con.size()>0){
a.SalesActivityDivision__c='有销售活动';
}else{
a.SalesActivityDivision__c='无销售活动';
}
update Oldacc; 
}
}
}
}