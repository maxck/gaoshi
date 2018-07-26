public class NewConfigrationList {
    
    String currentConfigId = '';
    public String configurationId  {set;get;} //选择的配置单内容。
    public String contractId  {set;get;}
    public List<Host__c> hostlists {set;get;}
    public List<OptionalAccessories__c> OptionalAccessoriesLists {set;get;}
    public List<TheRequiredAccessories__c> TheRequiredAccessorieslists {set;get;}
    public List<ExtendedWarrantyProduct__c> extendProduct {set;get;}
    public Boolean isRedirect {set;get;}
    Public Boolean isNew {set;get;}
    public ConfigurationList__c ConfigurationListPage{set;get;}
    public Decimal requiredNumber{get;set;}
    public Decimal hostStandardPrice {set;get;}
    public Decimal optStandardPrice {set;get;}
    public Decimal reqStandardPrice {set;get;}
    public Contract contract {get;set;}
    //public Order order {get;set;}
    public Decimal EquipmentPrice {get;set;}
    public Decimal EquipmentTotal {get;set;}
    public Decimal ExtendPrice{get;set;}
    public Decimal ExMonth{get;set;}
    public Decimal InputPrice{get;set;}
    public Decimal DiscountRate{get;set;}
    public String configListRecordTypeName{set;get;}
    
    public String getId {get;set;}
    public Decimal discount {get;set;}

    String configListRecordTypeId = Schema.SObjectType.ConfigurationList__c.getRecordTypeInfosByName().get('配置单-常规').getRecordTypeId();
    String configListLargeRecordTypeId = Schema.SObjectType.ConfigurationList__c.getRecordTypeInfosByName().get('配置单-大型').getRecordTypeId();
    String hostRecordTypeId = Schema.SObjectType.Host__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
    String optionRecordTypeId = Schema.SObjectType.OptionalAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
    String requiredRecordTypeId = Schema.SObjectType.TheRequiredAccessories__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
    String extendRecordTypeId = Schema.SObjectType.ExtendedWarrantyProduct__c.getRecordTypeInfosByName().get('配置单').getRecordTypeId();
    String stockRecordTypeId = Schema.SObjectType.ConfigurationList__c.getRecordTypeInfosByName().get('库存').getRecordTypeId();
    
    
    public NewConfigrationList(ApexPages.StandardController controller) {
        getId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('getId : '+ getId);
        
        currentConfigId = controller.getId();
        hostlists = new List<Host__c>();
        OptionalAccessoriesLists = new List<OptionalAccessories__c>();
        TheRequiredAccessorieslists = new List<TheRequiredAccessories__c>();
        extendProduct = new List<ExtendedWarrantyProduct__c>();
        contract = new Contract();
        //order = new Order();
        
        //获取当前记录的记录类型
        ConfigurationList__c currentConfigurationList = [select id,ContractReview__c,Opportuniy__c, configurationList__c, recordType.Name, ProductName__c,StandardPrice__c,FinalPrice__c, Model__c,EquipmentTotalPrice__c,EquipmentStandardPrice__c,EquipmentDiscount__c from ConfigurationList__c where id = :currentConfigId];
        ConfigurationListPage = currentConfigurationList;
        isRedirect = (currentConfigurationList.recordType.Name == '库存' ? true : false);
        configListRecordTypeName = currentConfigurationList.recordType.Name;
        contractId=ConfigurationListPage.ContractReview__c;
        System.debug('contractId' +contractId);
        if(ConfigurationListPage.EquipmentDiscount__c !=null){
            discount=ConfigurationListPage.EquipmentDiscount__c*100;
        }
        
        //获取当前的配置单记录下的主机和配件
        for (ConfigurationList__c tempConfigurationList : [select id,ContractReview__c,StandardPrice__c,FinalPrice__c, configurationList__c, ProductName__c, Model__c,EquipmentTotalPrice__c,EquipmentStandardPrice__c,EquipmentDiscount__c,     
                                (select Id, name, product__c, product__r.name, OpenQuotationUnitPrice__c, TotalPriceOfOpenQuotation__c, OriginalProductCode__c, Model__c, Describe__c, NumberTypeIN__c, NewInventoryCode__c,SystemStandardPricePer__c,SystemStandardTotalPrice__c from ConfigurationList__r),//主机
                                (select Id, name, product__c, product__r.name, OpenQuotationUnitPrice__c, TotalPriceOfOpen__c, OriginalInventoryCoding__c, Model__c, Describe__c, NumberTypeIN__c, NewInventoryCoding__c,SystemStandardPricePer__c,SystemStandardTotalPrice__c from Configurationlist44__r),//必选配件
                                (select Id, name, ProductName__c, ProductName__r.name, OpenQuotationUnitPrice__c, gkbjdj__c, OriginalInventoryCoding__c, Model__c, Describe__c, NumberTypeIN__c, NewInventoryCoding__c,SystemStandardPricePer__c,SystemStandardTotalPrice__c from ConfigurationList11__r),//可选配件
                                (select Id, name,ExtendWarrantyCode__c,ExtendMonth__c,SystemStandardPricePer__c,SystemStandardPriceTotal__c,UnitPrice__c,TotalPrice__c from ConfigurationListEW__r)//延保
                                from ConfigurationList__c
                                where id = :currentConfigId  limit 1])
        {   
            if(tempConfigurationList.configurationList__c != null){
            configurationId = (tempConfigurationList.configurationList__c != null ? tempConfigurationList.configurationList__c : '' );
            }
            InputPrice=tempConfigurationList.FinalPrice__c;
            EquipmentPrice=tempConfigurationList.EquipmentTotalPrice__c;
            DiscountRate=tempConfigurationList.EquipmentDiscount__c;
            hostlists.addAll(tempConfigurationList.ConfigurationList__r);
            //if (configListRecordTypeName == '配置单-常规')//如果是大型的话不计算必选配件的内日用，并且不显示。
            //{
                TheRequiredAccessorieslists.addAll(tempConfigurationList.Configurationlist44__r);
            //}
            OptionalAccessoriesLists.addAll(tempConfigurationList.ConfigurationList11__r);
            extendProduct.addAll(tempConfigurationList.ConfigurationListEW__r);
            isNew = false;
        }
        //主机数目为零，说明尚未添加配置单。 获取获取库存，即选择的配置单下面的 主机和配件。
        if (hostlists.size() == 0)
        {   
            isNew = true;
            for (ConfigurationList__c tempConfigurationList : [select id,ContractReview__c,StandardPrice__c,FinalPrice__c, configurationList__c, ProductName__c, Model__c,EquipmentTotalPrice__c,EquipmentStandardPrice__c,EquipmentDiscount__c,
                                (select name, product__c, product__r.name, OpenQuotationUnitPrice__c, TotalPriceOfOpenQuotation__c, OriginalProductCode__c, Model__c, Describe__c, NumberTypeIN__c, NewInventoryCode__c,SystemStandardPricePer__c,SystemStandardTotalPrice__c from ConfigurationList__r),//主机
                                (select name, product__c, product__r.name, OpenQuotationUnitPrice__c, TotalPriceOfOpen__c, OriginalInventoryCoding__c, Model__c, Describe__c, NumberTypeIN__c, NewInventoryCoding__c,SystemStandardPricePer__c,SystemStandardTotalPrice__c from Configurationlist44__r),//必选配件
                                (select name, ProductName__c, ProductName__r.name, OpenQuotationUnitPrice__c, gkbjdj__c, OriginalInventoryCoding__c, Model__c, Describe__c, NumberTypeIN__c, NewInventoryCoding__c,SystemStandardPricePer__c,SystemStandardTotalPrice__c from ConfigurationList11__r),//可选配件
                                (select name,ExtendWarrantyCode__c,ExtendMonth__c,SystemStandardPricePer__c,SystemStandardPriceTotal__c,UnitPrice__c,TotalPrice__c from ConfigurationListEW__r)//延保                               
                                from ConfigurationList__c
                                where id = :configurationId and recordTypeId = :stockRecordTypeId limit 1])
            {   
                hostlists.addAll(tempConfigurationList.ConfigurationList__r);
                for (Host__c tempHost : tempConfigurationList.ConfigurationList__r)
                {
                    requiredNumber = tempHost.NumberTypeIN__c ;
                }
                for (TheRequiredAccessories__c tempTheRequiredAccessories : tempConfigurationList.Configurationlist44__r)
                {
                    tempTheRequiredAccessories.NumberTypeIN__c = requiredNumber; 
                    
                }
                for (ExtendedWarrantyProduct__c tempExtendedWarrantyProducts : tempConfigurationList.ConfigurationlistEW__r)
                {
                    ExMonth=tempExtendedWarrantyProducts.ExtendMonth__c;
                    System.debug('ExMonth:' + ExMonth);
                    
                }
                TheRequiredAccessorieslists.addAll(tempConfigurationList.Configurationlist44__r);
                OptionalAccessoriesLists.addAll(tempConfigurationList.ConfigurationList11__r);
                //extendProduct.addAll(tempConfigurationList.ConfigurationListEW__r);
                
            }
        }
        system.debug('[Custom Log]hostlists ' + hostlists.size());
        system.debug('[Custom Log]TheRequiredAccessorieslists ' + TheRequiredAccessorieslists.size());
        system.debug('[Custom Log]OptionalAccessoriesLists ' + OptionalAccessoriesLists.size());
        system.debug('[Custom Log]extendProduct '+extendProduct.size());
        
        System.debug('ExtendPrice is ' + ExtendPrice);
        if (configListRecordTypeName == '配置单-常规')
        {
            List<Host__c> hls=[select OpenQuotationUnitPrice__c,SystemStandardTotalPrice__c,NumberTypeIN__c from Host__c where ConfigurationList__c=:currentConfigId];
            for(Host__c temp:hls){
           
               if(hls.size()>0&&temp.NumberTypeIN__c!=null){
                hostStandardPrice=temp.SystemStandardTotalPrice__c;
                }
            }
              
            List<TheRequiredAccessories__c> ls=[select id,SystemStandardTotalPrice__c,OpenQuotationUnitPrice__c,TotalPriceOfOpen__c,NumberTypeIN__c from TheRequiredAccessories__c where ConfigurationLst__c=:currentConfigId];
            decimal k=0;
            for(TheRequiredAccessories__c temp1:ls){
                
                if(ls.size()>0&&temp1.NumberTypeIN__c!=null){
                    k+=temp1.SystemStandardTotalPrice__c;
                }
                reqStandardPrice=k;
            }          
            List<OptionalAccessories__c> ls1=[select SystemStandardTotalPrice__c,OpenQuotationUnitPrice__c,NumberTypeIN__c from OptionalAccessories__c where ConfigurationList__c=:currentConfigId];
            decimal l=0;
            for(OptionalAccessories__c temp2:ls1){
                if(ls1.size()>0&&temp2.SystemStandardTotalPrice__c!=null){
                    l+=temp2.SystemStandardTotalPrice__c;
                }
                optStandardPrice=l;
            }                    
            if(hostStandardPrice!=null){
                EquipmentPrice=hostStandardPrice+reqStandardPrice+optStandardPrice;                    
            }
            
            
            ConfigurationListPage.EquipmentStandardPrice__c=EquipmentPrice;
            InputPrice=ConfigurationListPage.FinalPrice__c;
        }
    }
    
    
    
    
    //保存用户已经填写的内容。
    public Pagereference saveButton ()
    {   
        List<Host__c> updateHosts = new List<Host__c>();
        List<OptionalAccessories__c> updateOptionalAccessoriesLists = new List<OptionalAccessories__c>();
        List<TheRequiredAccessories__c> updateTheRequiredAccessorieslists = new List<TheRequiredAccessories__c>();
        List<ExtendedWarrantyProduct__c> updateExtendedWarrantyProducts = new List<ExtendedWarrantyProduct__c>();
        
        Decimal hostTotalPrice = 0;//系统基准价总价（主机）
        Decimal requiredTotalPrice = 0; //系统基准价总价（必选）
        Decimal optionalTotalPrice = 0;//系统基准价总价（可选）
        Decimal warrentyTotalPrice = 0;//成价总价 （延保配件）
        Decimal warrentyStandardPrice = 0;//系统基准价总价（延保配件）
        for (Host__c tempHost : hostlists)
        {   
            
            Host__c updateHost = new Host__c();
            if (tempHost.id != null && isNew == false)
            {
                updateHost.Id = tempHost.Id;
                system.debug('[Custom Log]tempHost.id ' + tempHost.id);
            }
            requiredNumber = tempHost.NumberTypeIN__c ;
            updateHost.name = tempHost.name;
            updateHost.ConfigurationList__c = currentConfigId;
            updateHost.product__c = tempHost.product__c;
            updateHost.NumberTypeIN__c = tempHost.NumberTypeIN__c;
            updateHost.SystemStandardPricePer__c = tempHost.SystemStandardPricePer__c;
            updateHost.recordTypeId = hostRecordTypeId ;
            updateHosts.add(updateHost);           
            if (configListRecordTypeName == '配置单-大型')
            {
                hostTotalPrice = hostTotalPrice + ((tempHost.SystemStandardPricePer__c == null ? 0 : tempHost.SystemStandardPricePer__c) * tempHost.NumberTypeIN__c );//系统基准价单价 * 数量
            }
           
        }
        
        for (ExtendedWarrantyProduct__c tempExtendedWarrantyProduct : extendProduct)
        {   
             ExtendedWarrantyProduct__c updateExtendedWarrantyProduct = new ExtendedWarrantyProduct__c();
             
                updateExtendedWarrantyProduct.Id = tempExtendedWarrantyProduct.Id;
                system.debug('[Custom Log]tempHost.id ' + tempExtendedWarrantyProduct.id);
             
             updateExtendedWarrantyProduct.SystemStandardPricePer__c = tempExtendedWarrantyProduct.SystemStandardPricePer__c;//系统基准价单价
             updateExtendedWarrantyProduct.UnitPrice__c = tempExtendedWarrantyProduct.SystemStandardPricePer__c;//成交单价
             updateExtendedWarrantyProduct.Name = tempExtendedWarrantyProduct.Name;
             
             ExMonth = tempExtendedWarrantyProduct.ExtendMonth__c;
             updateExtendedWarrantyProduct.ConfigurationList__c = currentConfigId;
             updateExtendedWarrantyProduct.ExtendMonth__c=ExMonth;
             updateExtendedWarrantyProduct.recordTypeId=extendRecordTypeId;
             if (configListRecordTypeName == '配置单-常规')
             {   
                if(InputPrice!=null){
                    if(ExMonth<=24){
                        updateExtendedWarrantyProduct.TotalPrice__c =InputPrice*(ExMonth/12)*0.03;
                    }if(ExMonth>24&&ExMonth<=48){
                        updateExtendedWarrantyProduct.TotalPrice__c =InputPrice*(ExMonth/12)*0.03*0.9;
                    }if(ExMonth>48){
                        updateExtendedWarrantyProduct.TotalPrice__c =InputPrice*(ExMonth/12)*0.03*0.8;
                    }
                }
                
                EquipmentTotal=updateExtendedWarrantyProduct.TotalPrice__c;
                if(EquipmentTotal!=null&&InputPrice!=null){
                    ConfigurationListPage.EquipmentTotalPrice__c=InputPrice-EquipmentTotal;
                   //DiscountRate=1-EquipmentPrice/EquipmentTotal;
                    DiscountRate=1-ConfigurationListPage.EquipmentTotalPrice__c/EquipmentPrice;
                }
                
                ConfigurationListPage.EquipmentDiscount__c=DiscountRate;
                
            }   
            else if (configListRecordTypeName == '配置单-大型')
            {   
                
                updateExtendedWarrantyProduct.SystemStandardPriceTotal__c = ((tempExtendedWarrantyProduct.SystemStandardPricePer__c == null ? 0 : tempExtendedWarrantyProduct.SystemStandardPricePer__c) * tempExtendedWarrantyProduct.ExtendMonth__c ); //系统基准价总价：系统基准价单价*数量（月）
                updateExtendedWarrantyProduct.TotalPrice__c = ((tempExtendedWarrantyProduct.UnitPrice__c == null ? 0 : tempExtendedWarrantyProduct.UnitPrice__c) * tempExtendedWarrantyProduct.ExtendMonth__c );//成价总价：成交单价*数量（月） 
                warrentyTotalPrice = warrentyTotalPrice + ((tempExtendedWarrantyProduct.UnitPrice__c == null ? 0 : tempExtendedWarrantyProduct.UnitPrice__c) * tempExtendedWarrantyProduct.ExtendMonth__c );//成价总价：成交单价*数量（月）
                warrentyStandardPrice = warrentyStandardPrice + ((tempExtendedWarrantyProduct.SystemStandardPricePer__c == null ? 0 : tempExtendedWarrantyProduct.SystemStandardPricePer__c) * tempExtendedWarrantyProduct.ExtendMonth__c );//系统基准价总价：系统基准价单价*数量（月）
            }      
            updateExtendedWarrantyProducts.add(updateExtendedWarrantyProduct);
        }
        
        for (OptionalAccessories__c tempOptionalAccessories : OptionalAccessoriesLists)
        {   
            OptionalAccessories__c updateOptionalAccessories = new OptionalAccessories__c();
            if (tempOptionalAccessories.id != null && isNew == false)
            {
                updateOptionalAccessories.Id = tempOptionalAccessories.Id;
            }
            updateOptionalAccessories.Name = tempOptionalAccessories.Name;
            updateOptionalAccessories.ConfigurationList__c = currentConfigId;
            updateOptionalAccessories.ProductName__c= tempOptionalAccessories.ProductName__c;
            updateOptionalAccessories.NumberTypeIN__c = tempOptionalAccessories.NumberTypeIN__c;
            updateOptionalAccessories.SystemStandardPricePer__c = tempOptionalAccessories.SystemStandardPricePer__c;
            updateOptionalAccessories.recordTypeId = optionRecordTypeId;
            updateOptionalAccessoriesLists.add(updateOptionalAccessories);
            if (configListRecordTypeName == '配置单-大型')
            {
                optionalTotalPrice = optionalTotalPrice + ((tempOptionalAccessories.SystemStandardPricePer__c == null ? 0 : tempOptionalAccessories.SystemStandardPricePer__c) * tempOptionalAccessories.NumberTypeIN__c );//成价总价：成交单价*数量（月）
            }
        }
        
        for (TheRequiredAccessories__c tempTheRequiredAccessories : TheRequiredAccessorieslists)
        {   
            TheRequiredAccessories__c updateTheRequiredAccessories = new TheRequiredAccessories__c();
            if (tempTheRequiredAccessories.id != null && isNew == false)
            {
                updateTheRequiredAccessories.Id = tempTheRequiredAccessories.Id;
            }
            updateTheRequiredAccessories.Name = tempTheRequiredAccessories.Name;
            updateTheRequiredAccessories.ConfigurationLst__c = currentConfigId;
            updateTheRequiredAccessories.product__c = tempTheRequiredAccessories.product__c;
            updateTheRequiredAccessories.NumberTypeIN__c = requiredNumber;
            updateTheRequiredAccessories.SystemStandardPricePer__c = tempTheRequiredAccessories.SystemStandardPricePer__c;
            updateTheRequiredAccessories.recordTypeId = requiredRecordTypeId;
            updateTheRequiredAccessorieslists.add(updateTheRequiredAccessories);
            
            if (configListRecordTypeName == '配置单-大型')
            {
                requiredTotalPrice = requiredTotalPrice + ((tempTheRequiredAccessories.SystemStandardPricePer__c == null ? 0 : tempTheRequiredAccessories.SystemStandardPricePer__c) * (tempTheRequiredAccessories.NumberTypeIN__c == null ? 0 : tempTheRequiredAccessories.NumberTypeIN__c) );//系统基准价单价 * 数量
            }
        }
        
        //计算
        //系统基准价总价：设备基准总价+系统基准价总价（延保配件）
        //设备基准总价：系统基准价总价（主机）+系统基准价总价（必选）+系统基准价总价（可选）
        //成交总价：人工输入 inputField
        //设备成交总价：成交总价-成交总价（延保配件）
        //设备折扣率：1-设备成价总价/设备基准总价
        if(configListRecordTypeName == '配置单-大型')
        {   
            system.debug('[Custom Log]ConfigurationListPage.FinalPrice__c ' + ConfigurationListPage.FinalPrice__c);
            system.debug('[Custom Log]warrentyTotalPric ' + warrentyTotalPrice);
            ConfigurationListPage.EquipmentStandardPrice__c = hostTotalPrice + requiredTotalPrice + optionalTotalPrice;//设备基准总价：系统基准价总价（主机）+系统基准价总价（必选）+系统基准价总价（可选）
            ConfigurationListPage.SystemStandardTotalPrice__c = ConfigurationListPage.EquipmentStandardPrice__c + warrentyStandardPrice;//系统基准价总价：设备基准总价+系统基准价总价（延保配件）
            ConfigurationListPage.EquipmentTotalPrice__c = (ConfigurationListPage.FinalPrice__c - warrentyTotalPrice);//设备成交总价：成交总价-成交总价（延保配件）
            ConfigurationListPage.EquipmentDiscount__c = (ConfigurationListPage.EquipmentStandardPrice__c == 0 ? 0 : ConfigurationListPage.EquipmentTotalPrice__c/ConfigurationListPage.EquipmentStandardPrice__c);//设备折扣率：设备成价总价/设备基准总价
        }
        try
        {
            Database.upsert(updateHosts, Host__c.Fields.Id);
            Database.upsert(updateOptionalAccessoriesLists, OptionalAccessories__c.Fields.Id);
            Database.upsert(updateTheRequiredAccessorieslists, TheRequiredAccessories__c.Fields.Id);
            Database.upsert(ConfigurationListPage,ConfigurationList__c.Field.Id);
            Database.upsert(updateExtendedWarrantyProducts,ExtendedWarrantyProduct__c.Fields.Id);
            
        }
        catch (Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'保存数据报错，请将错误信息发送至系统管理员：' + e));
            return null;
        } 

        PageReference acctPage = new Pagereference('/apex/ConfigrationListPage?id=' + currentConfigId);
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    //保存用户已经填写的内容。
    public Pagereference redirectToViewPage ()
    {   
        if (isRedirect == true)
        {
            return new Pagereference('/apex/ConfigurationView' );
        }
        else
        {
            return null;
        }
    }
    
    public Pagereference cancleButton()
    {
        PageReference acctPage = new Pagereference('/' + contractId);
        acctPage.setRedirect(true);
        return acctPage;
    }
    //clone page
    public PageReference clonePage(){
        ConfigurationList__c newRecord = ConfigurationListPage.clone(false,true);
        newRecord.Name = '复制'; 
        insert newRecord;
        PageReference oppPage = new Pagereference('/' + ConfigurationListPage.Opportuniy__c);
        oppPage.setRedirect(true);
        return oppPage;
    }
    //Print
    public  PagereFerence  print(){
        PageReference printPage = new Pagereference('/apex/ConfigrationListPrintPage3?id=' + getId );
        printPage.setRedirect(true);
        return printPage;     
    }
    //Print1
    public  PagereFerence  print1(){
        PageReference printPage1 = new Pagereference('/apex/ConfigrationListPrintPage1?id=' + getId );
        printPage1.setRedirect(true);
        return printPage1;     
    }
    //Print2
    public  PagereFerence  print2(){
        PageReference printPage2 = new Pagereference('/apex/ConfigrationListPrintPage2?id=' + getId );
        printPage2.setRedirect(true);
        return printPage2;     
    }
    
        
}