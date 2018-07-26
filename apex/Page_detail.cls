public class Page_detail {
    
    public List<Event> EventList2 {set; get;}
    public List<Event>  AllEvents {set;get;}
    public List<User> AllContacts {set;get;}
    public List<WrapperOpportunity>   AllOpportunities{get;set;}
    public Integer No{set;get;}
    public Integer week{get;set;}
    public Date startDateOfWeek{set;get;}
    public Date endDateOfWeek{set;get;}
    
    
    public Page_detail() {
        
    }
    
    public static Map<String, String> number2MonthName = new Map<String, String>
        {
            'Mon' => '星期一',
            'Tue' => '星期二',
            'Wed' => '星期三',
            'Thu' => '星期四',
            'Fri' => '星期五',
            'Sat' => '星期六',
            'Sun' => '星期日'
            
        }; 
    
    public void query(){
         
       if(No >= 52 || No <= 1){
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'请输入正确的周序号'));
       } 
       
       AllContacts  =  [SELECT FirstName, LastName, TertiarySector__c  FROM User];
    
        AllOpportunities = new List<WrapperOpportunity>();
        
        Set<Id> opportunityIds = new Set<Id>();//获取产品用
        for (Opportunity tempOpportunity : [select id, FinalCustomer__c, FinalCustomer__r.name, Name, Amount,Description__c  
                                                from Opportunity where  ownerid = :userinfo.getUserid() and week__c =: No AND year__c = 0])
        {
            opportunityIds.add(tempOpportunity.id);
        }
        //获取 品牌/型号
        Map<Id, String> oppId2ProductName = new Map<Id, String>();
        for (OpportunityLineItem tempOpportunityLineItem : [select id, Opportunityid, Product2.name from OpportunityLineItem where Opportunityid IN :opportunityIds])
        {
            if (oppId2ProductName.containskey(tempOpportunityLineItem.id))
            {   
                String tempProductName = oppId2ProductName.get(tempOpportunityLineItem.Opportunityid);
                tempProductName = tempProductName + ', ' + tempOpportunityLineItem.Product2.name;
                oppId2ProductName.put(tempOpportunityLineItem.Opportunityid, tempProductName);
                System.debug('tempProductName :'+ tempProductName);
            }
            else
            {
                
                oppId2ProductName.put(tempOpportunityLineItem.Opportunityid, tempOpportunityLineItem.Product2.name);
            }       
            
        }
        
        for (Opportunity tempOpportunity : [select id, FinalCustomer__c, FinalCustomer__r.name, Name, Amount,Description__c  from Opportunity where week__c =: No AND year__c = 0 and ownerid = :userinfo.getUserid()])
        {
            WrapperOpportunity tempWrapperOpportunity = new WrapperOpportunity();
            tempWrapperOpportunity.endAccountName = tempOpportunity.FinalCustomer__r.name;
            system.debug('tempWrapperOpportunity.endAccountName :'+ tempWrapperOpportunity.endAccountName);
            tempWrapperOpportunity.opportunityName = tempOpportunity.Name;
            system.debug('tempWrapperOpportunity.opportunityName :'+ tempWrapperOpportunity.opportunityName);
            tempWrapperOpportunity.amount = String.valueOf(tempOpportunity.Amount);
            system.debug('tempWrapperOpportunity.amount :'+ tempWrapperOpportunity.amount );
            //tempWrapperOpportunity.contacts = (accountId2Name.containsKey(tempOpportunity.FinalCustomer__c) ? accountId2Name.get(tempOpportunity.FinalCustomer__c) : '');
            
            system.debug('tempWrapperOpportunity.TimeInstallation :'+tempWrapperOpportunity.TimeInstallation);
            tempWrapperOpportunity.description = (String.isBlank(tempOpportunity.Description__c) ? '' : tempOpportunity.Description__c);
            system.debug(' tempWrapperOpportunity.description :'+ tempWrapperOpportunity.description);
            tempWrapperOpportunity.brandAndType = (oppId2ProductName.containsKey(tempOpportunity.id) ? oppId2ProductName.get(tempOpportunity.id) : '');
            system.debug('tempWrapperOpportunity.brandAndType :'+ tempWrapperOpportunity.brandAndType);
            AllOpportunities.add(tempWrapperOpportunity);
        }
    
      // Allzbs =  [SELECT ClientName__c,OrderID__c,OrderAmount__c,ReturnedMoney__c,Surplus__c,Overdue__c FROM zb__c where  Field1__c =: No AND Year1__c = 0]; 
    
        Map<String, DateTime> startEndDayMap = getWeekStartAndEnd(Date.today().year(), No);
        DateTime startDay = startEndDayMap.get('startDay');
        DateTime endDay = startEndDayMap.get('endDay');
        startDateOfWeek = startDay.date();
        endDateOfWeek = endDay.date();
       
       
        DateTime nextStartday  =  startday ;
        DateTime nextStartday1 = nextStartday.addDays(7);
       
        DateTime nextEndday  =  endDay ;
        DateTime nextEndday1 = nextEndday .addDays(7);
      
      AllEvents = [SELECT StartDateTime,WeekDay__c,ActivityDate__c,AccountName__c,lxr__c,ActivityDescription__c,NeedSupport__c,Comment__c,CompletionStatus__c FROM Event where StartDateTime > = :startDay AND StartDateTime < = : endDay and ownerid = :userinfo.getUserid()  ORDER BY  StartDateTime ASC ];
      for(Event ev : AllEvents ){
          
          Datetime dt = ev.StartDateTime.addHours(8);
          String weekDay = number2MonthName.get(dt.formatGmt('EEE'));
          ev.WeekDay__c = weekDay ;
          }    
      
      
      
      EventList2 = [SELECT StartDateTime,WeekDay__c,ActivityDate__c,AccountName__c,lxr__c,ActivityDescription__c,NeedSupport__c,Comment__c,CompletionStatus__c FROM Event where StartDateTime > = :nextStartday1 AND StartDateTime < = : nextEndday1 and ownerid = :userinfo.getUserid() ORDER BY  StartDateTime ASC ]; 
      for(Event ev2 : EventList2 ){
          Datetime dt = ev2.StartDateTime.addHours(8);
          String weekDay = number2MonthName.get(dt.formatGmt('EEE'));
          ev2.WeekDay__c = weekDay ;
          }    
      

    }
    

    private Map<String, DateTime> getWeekStartAndEnd(Integer year, Integer weekNo) {
        System.debug('=====[customer log]===== method: getWeekStartAndEnd start');
        System.debug('=====[customer log]===== [param] year' + year);
        System.debug('=====[customer log]===== [param] weekNo' + weekNo);
        Map<String, DateTime> dateMap = new Map<String, DateTime>();

        Datetime beginDayOfYear = Datetime.newInstance(year, 1, 1);

        Integer numberOfDays = 365;
        
        if (Date.isLeapYear(year)) {
            numberOfDays = 366;
        }
        Datetime startDay;
        Datetime endDay;
        for (Integer i = 0; i < numberOfDays; i++) {
            Datetime cursorDay = beginDayOfYear.addDays(i);
            if (Integer.valueOf(cursorDay.formatGmt('w')) == weekNo) {
                startDay = cursorDay;
                break;
            }
        }

        endDay = startDay.addDays(6);

        dateMap.put('startDay', startDay);
        dateMap.put('endDay', endDay);

        return dateMap;
    }
    
    
     public class WrapperOpportunity
    {
        public String endAccountName{set;get;}
        public String opportunityName{set;get;}
        public String amount{set;get;}
        public String contacts{set;get;}
        public String TimeInstallation{set;get;}
        public String description{set;get;}
        public String brandAndType{set;get;}
        
    } 
    
    
}
