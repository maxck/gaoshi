@isTest(SeeAlldata=true)
private class NewConfigrationListTest {

    static testMethod void myUnitTest() {
    
        
        Profile p = [select id from Profile limit 1];
        system.assert(p.id != null);
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        
        UserName=uniqueUserName);
             
        Account a1  =  new Account() ; 
        a1.Name = 'test1230';
        a1.city__c = '福州市';
        a1.province__c = '福建省';
        a1.Cunty__c = '1' ;
        a1.Duty__c = '1' ;
        a1.ContactNumber__c = '123'; 
        a1.Gender__c = '男';
        a1.CustomerApprovalStatus__c='已审批';
        insert a1 ;
        
        Opportunity  opp = new Opportunity();   
        opp.AccountId = a1.Id;
        opp.FinalCustomer__c = a1.Id;
        opp.StageName = '潜在阶段';
        opp.ProcurementMethod__c = '院内采购';
        opp.BusinessSource__c = '渠道';
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        insert opp;
        
        Product3__c p1=new Product3__c();
        p1.Name='test主机';
        p1.OpenQuotationUnitPrice__c= 100;
        p1.OriginalInventoryCoding__c='00000';
        p1.Model__c='model1';
        p1.Describe__c='describe';
        p1.Number__c= 1;
        p1.NewInventoryCoding__c='11111';
        p1.Type__c='主机';
        insert p1;
        
        Product3__c p2=new Product3__c();
        p2.Name='test可选配件';
        p2.OpenQuotationUnitPrice__c= 10;
        p2.OriginalInventoryCoding__c='10000';
        p2.Model__c='model1';
        p2.Describe__c='describe';
        p2.Number__c= 1;
        p2.NewInventoryCoding__c='21111';
        p2.Type__c='可选配件';
        insert p2;
        
        Product3__c p3=new Product3__c();
        p3.Name='test必选配件';
        p3.OpenQuotationUnitPrice__c= 10;
        p3.OriginalInventoryCoding__c='20000';
        p3.Model__c='model1';
        p3.Describe__c='describe';
        p3.Number__c= 1;
        p3.NewInventoryCoding__c='31111';
        p3.Type__c='必选配件';
        insert p3;
        
        Product3__c p4=new Product3__c();
        p4.Name='test延保配件';
       // p4.Type__c='延保配件';
        insert p4;
        
       Order order = new Order();
    //order.OwnerId = '0056F0000082F6LQAU';
    order.AccountId = a1.Id;
    //order.RecordTypeId = '0126F000001UVcYQAW';
    order.EffectiveDate = Date.newInstance(2018,04,23);
        
    order.Status = 'Draft';
    
        insert order;
        
        ConfigurationList__c config=new ConfigurationList__c();
        Id TypeId = Schema.SObjectType.ConfigurationList__c.getRecordTypeInfosByName().get('库存').getRecordTypeId();
        config.RecordTypeId = TypeId;
        config.Opportuniy__c=opp.Id;
        config.configurationList__c=config.Name;
        config.Model__c='test1';
        config.order__c=order.Id;
        insert config;
        
        

        
        Host__c host=new Host__c();
        host.Name='new host';
        Id hostTypeId = Schema.SObjectType.Host__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        host.RecordTypeId = hostTypeId;
        host.product__c=p1.Id;
        host.ConfigurationList__c=config.Id;
        insert host;
        
        TheRequiredAccessories__c req=new TheRequiredAccessories__c();
        req.Name='new req';
        Id reqTypeId = Schema.SObjectType.TheRequiredAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        req.RecordTypeId = reqTypeId;
        req.product__c=p2.Id;
        req.ConfigurationLst__c=config.Id;
        insert req;
        
        OptionalAccessories__c opt=new OptionalAccessories__c();
        opt.Name='new opt';
        Id optTypeId = Schema.SObjectType.OptionalAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        opt.RecordTypeId = optTypeId;
        opt.ProductName__c=p3.Id;
        opt.ConfigurationList__c=config.Id;
        insert opt;
        
        ExtendedWarrantyProduct__c ext=new ExtendedWarrantyProduct__c();
        ext.Name='new ext';
        
        //Id extTypeId = Schema.SObjectType.ExtendedWarrantyProduct__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        //ext.RecordTypeId = extTypeId;
        ext.ConfigurationList__c=config.Id;
        insert ext;
        
        //Test.StartTest(); 

            PageReference pageRef = Page.ConfigrationListPage; 
            pageRef.getParameters().put('configurationId', config.Id);
            Test.setCurrentPage(pageRef);
            ConfigurationList__c cfg=new ConfigurationList__c(name='test');
            ApexPages.StandardController sc=new ApexPages.StandardController(config);
            
            NewConfigrationList con=new NewConfigrationList(sc);
            //System.assert(con!=null);
            
            List<ConfigurationList__c> ls =[select Id,name from ConfigurationList__c where Id=:config.RecordTypeId];
            List<Host__c> hls=con.hostlists;
            hls.add(host);
            List<OptionalAccessories__c> ols=con.OptionalAccessoriesLists;
            ols.add(opt);
            List<TheRequiredAccessories__c> rls=con.TheRequiredAccessorieslists;
            rls.add(req);
            List<ExtendedWarrantyProduct__c> els=con.extendProduct;
            els.add(ext);
            config.Id=con.configurationId;
        
            con.saveButton();
            con.redirectToViewPage();
            con.cancleButton();
        
            
    }
    
    static testMethod void myUnitTest1() {
    
        
        Profile p = [select id from Profile limit 1];
        system.assert(p.id != null);
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        
        UserName=uniqueUserName);
             
        Account a1  =  new Account() ; 
        a1.Name = 'test1230';
        a1.city__c = '福州市';
        a1.province__c = '福建省';
        a1.Cunty__c = '1' ;
        a1.Duty__c = '1' ;
        a1.ContactNumber__c = '123'; 
        a1.Gender__c = '男';
        a1.CustomerApprovalStatus__c='已审批';
        insert a1 ;
        
        Opportunity  opp = new Opportunity();   
        opp.AccountId = a1.Id;
        opp.FinalCustomer__c = a1.Id;
        opp.StageName = '潜在阶段';
        opp.ProcurementMethod__c = '院内采购';
        opp.BusinessSource__c = '渠道';
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        insert opp;
        
        Product3__c p1=new Product3__c();
        p1.Name='test主机';
        p1.OpenQuotationUnitPrice__c= 100;
        p1.OriginalInventoryCoding__c='00000';
        p1.Model__c='model1';
        p1.Describe__c='describe';
        p1.Number__c= 1;
        p1.NewInventoryCoding__c='11111';
        p1.Type__c='主机';
        insert p1;
        
        Product3__c p2=new Product3__c();
        p2.Name='test可选配件';
        p2.OpenQuotationUnitPrice__c= 10;
        p2.OriginalInventoryCoding__c='10000';
        p2.Model__c='model1';
        p2.Describe__c='describe';
        p2.Number__c= 1;
        p2.NewInventoryCoding__c='21111';
        p2.Type__c='可选配件';
        insert p2;
        
        Product3__c p3=new Product3__c();
        p3.Name='test必选配件';
        p3.OpenQuotationUnitPrice__c= 10;
        p3.OriginalInventoryCoding__c='20000';
        p3.Model__c='model1';
        p3.Describe__c='describe';
        p3.Number__c= 1;
        p3.NewInventoryCoding__c='31111';
        p3.Type__c='必选配件';
        insert p3;
        
       Order order = new Order();
    //order.OwnerId = '0056F0000082F6LQAU';
    order.AccountId = a1.Id;
    //order.RecordTypeId = '0126F000001UVcYQAW';
    order.EffectiveDate = Date.newInstance(2018,04,23);
        
    order.Status = 'Draft';
    
        insert order;
        
        ConfigurationList__c config=new ConfigurationList__c();
        Id TypeId = Schema.SObjectType.ConfigurationList__c.getRecordTypeInfosByName().get('库存').getRecordTypeId();
        config.RecordTypeId = TypeId;
        //config.RecordType.Name = '配置单-常规';
        config.Opportuniy__c=opp.Id;
        config.configurationList__c=config.Name;
        config.Model__c='test1';
        config.order__c=order.Id;
        insert config;
        
        

        
       
        
        TheRequiredAccessories__c req=new TheRequiredAccessories__c();
        req.Name='new req';
        Id reqTypeId = Schema.SObjectType.TheRequiredAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        req.RecordTypeId = reqTypeId;
        req.product__c=p2.Id;
        req.ConfigurationLst__c=config.Id;
        insert req;
        
        OptionalAccessories__c opt=new OptionalAccessories__c();
        opt.Name='new opt';
        Id optTypeId = Schema.SObjectType.OptionalAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        opt.RecordTypeId = optTypeId;
        opt.ProductName__c=p3.Id;
        opt.ConfigurationList__c=config.Id;
        insert opt;
        
        //Test.StartTest(); 

            PageReference pageRef = Page.ConfigrationListPage; 
            pageRef.getParameters().put('configurationId', config.Id);
            Test.setCurrentPage(pageRef);
            ConfigurationList__c cfg=new ConfigurationList__c(name='test');
            ApexPages.StandardController sc=new ApexPages.StandardController(config);
            
            NewConfigrationList con=new NewConfigrationList(sc);
            //System.assert(con!=null);
            
            List<ConfigurationList__c> ls =[select Id,name from ConfigurationList__c where Id=:config.RecordTypeId];
            List<Host__c> hls=con.hostlists;
            
            //hls.add(host);
                
            List<OptionalAccessories__c> ols=con.OptionalAccessoriesLists;
            ols.add(opt);
            List<TheRequiredAccessories__c> rls=con.TheRequiredAccessorieslists;
            rls.add(req);
            config.Id=con.configurationId;
        
            con.saveButton();
            con.redirectToViewPage();
            con.cancleButton();
        
            
    }
    
     static testMethod void myUnitTest2() {
    
        
        Profile p = [select id from Profile limit 1];
        system.assert(p.id != null);
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        
        UserName=uniqueUserName);
             
        Account a1  =  new Account() ; 
        a1.Name = 'test1230';
        a1.city__c = '福州市';
        a1.province__c = '福建省';
        a1.Cunty__c = '1' ;
        a1.Duty__c = '1' ;
        a1.ContactNumber__c = '123'; 
        a1.Gender__c = '男';
        a1.CustomerApprovalStatus__c='已审批';
        insert a1 ;
        
        Opportunity  opp = new Opportunity();   
        opp.AccountId = a1.Id;
        opp.FinalCustomer__c = a1.Id;
        opp.StageName = '潜在阶段';
        opp.ProcurementMethod__c = '院内采购';
        opp.BusinessSource__c = '渠道';
        opp.Name = 'Test Opportunity';
        opp.CloseDate = date.today();
        insert opp;
        
        Product3__c p1=new Product3__c();
        p1.Name='test主机';
        p1.OpenQuotationUnitPrice__c= 100;
        p1.OriginalInventoryCoding__c='00000';
        p1.Model__c='model1';
        p1.Describe__c='describe';
        p1.Number__c= 1;
        p1.NewInventoryCoding__c='11111';
        p1.Type__c='主机';
        insert p1;
        
        Product3__c p2=new Product3__c();
        p2.Name='test可选配件';
        p2.OpenQuotationUnitPrice__c= 10;
        p2.OriginalInventoryCoding__c='10000';
        p2.Model__c='model1';
        p2.Describe__c='describe';
        p2.Number__c= 1;
        p2.NewInventoryCoding__c='21111';
        p2.Type__c='可选配件';
        insert p2;
        
        Product3__c p3=new Product3__c();
        p3.Name='test必选配件';
        p3.OpenQuotationUnitPrice__c= 10;
        p3.OriginalInventoryCoding__c='20000';
        p3.Model__c='model1';
        p3.Describe__c='describe';
        p3.Number__c= 1;
        p3.NewInventoryCoding__c='31111';
        p3.Type__c='必选配件';
        insert p3;
        
       Order order = new Order();
    //order.OwnerId = '0056F0000082F6LQAU';
    order.AccountId = a1.Id;
    //order.RecordTypeId = '0126F000001UVcYQAW';
    order.EffectiveDate = Date.newInstance(2018,04,23);
        
    order.Status = 'Draft';
    
        insert order;
        
        ConfigurationList__c config=new ConfigurationList__c();
        Id TypeId = Schema.SObjectType.ConfigurationList__c.getRecordTypeInfosByName().get('配置单-常规').getRecordTypeId();
        config.RecordTypeId = TypeId;
        //config.RecordType.Name = '配置单-常规';
        config.Opportuniy__c=opp.Id;
        config.configurationList__c=config.Name;
        config.Model__c='test1';
        config.order__c=order.Id;
        insert config;
        
        

        
       
        
        TheRequiredAccessories__c req=new TheRequiredAccessories__c();
        req.Name='new req';
        Id reqTypeId = Schema.SObjectType.TheRequiredAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        req.RecordTypeId = reqTypeId;
        req.product__c=p2.Id;
        req.ConfigurationLst__c=config.Id;
        insert req;
        
        OptionalAccessories__c opt=new OptionalAccessories__c();
        opt.Name='new opt';
        Id optTypeId = Schema.SObjectType.OptionalAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
        opt.RecordTypeId = optTypeId;
        opt.ProductName__c=p3.Id;
        opt.ConfigurationList__c=config.Id;
        insert opt;
        
        //Test.StartTest(); 

            PageReference pageRef = Page.ConfigrationListPage; 
            pageRef.getParameters().put('configurationId', config.Id);
            Test.setCurrentPage(pageRef);
            ConfigurationList__c cfg=new ConfigurationList__c(name='test');
            ApexPages.StandardController sc=new ApexPages.StandardController(config);
            
            NewConfigrationList con=new NewConfigrationList(sc);
            //System.assert(con!=null);
            
            List<ConfigurationList__c> ls =[select Id,name from ConfigurationList__c where Id=:config.RecordTypeId];
            List<Host__c> hls=con.hostlists;
            
            //hls.add(host);
                
            List<OptionalAccessories__c> ols=con.OptionalAccessoriesLists;
            ols.add(opt);
            List<TheRequiredAccessories__c> rls=con.TheRequiredAccessorieslists;
            rls.add(req);
            config.Id=con.configurationId;
        
            con.saveButton();
            con.redirectToViewPage();
            con.cancleButton();
            con.print();
            con.print1();
            con.print2();
            
    }
}