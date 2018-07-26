@isTest
public class ConfigureTriggerTest {
  static testMethod void Test()
    { 
    Account account = new Account();
  account.Name = '111';
  //account.RecordTypeId = '01290000000mqmZAAQ';
  account.CurrencyIsoCode = 'CNY';
  //account.OwnerId = '0056F0000082F6LQAU';
  account.city__c = '东城区';
  account.province__c = '北京市';
  account.AccountNature__c = '公立医院';
  account.AccountType__c = '公立综合';
  account.NewAccount__c = '是';
  account.Cunty__c = '11';
  account.StateHospital__c = '潜客';
  account.BigCustomer__c = '是';
  account.SalesOpportunityDifferentiation__c = '无欧堡销售机会';
  account.CustomerFirst__c = '是';
  account.Classify__c = '外部客户';
  account.TypeEnterprise__c = '医疗机构';
  account.CountyHospital__c = '是';
  account.Grade__c = '公立三级';
  account.CustomerApprovalStatus__c = '草稿';
  account.RegularOpportunities__c = '无常规销售机会';
  account.RefractionOpportunity__c = '无屈光销售机会';
  account.PZgz__c = false;
  account.DQjlgz__c = false;
  account.XSgz__c = false;
  account.ZCgz__c = false;
  account.EVPdx__c = false;
  account.OBZJ__c = false;
  account.OBQYJL__c = false;
  account.OBdqjl__c = false;
    insert account;
        
    Opportunity opportunity = new Opportunity();
  opportunity.AccountId = account.Id;
  //opportunity.RecordTypeId = '0126F000001YcRqQAK';
  opportunity.Name = '222';
  opportunity.StageName = '潜在阶段';
  opportunity.Amount = 0.0;
  opportunity.Probability = 10.0;
  opportunity.CloseDate = Date.newInstance(2018,06,13);
  opportunity.ForecastCategoryName = '忽略';
  opportunity.CurrencyIsoCode = 'CNY';
  //opportunity.OwnerId = '0056F0000082F6LQAU';
  opportunity.City__c = '东城区';
  opportunity.ProcurementMethod__c = '招投标';
  opportunity.BusinessSource__c = '专家推荐';
  opportunity.BusinessType__c = false;
  opportunity.FinalCustomer__c = account.Id;
  opportunity.BusinessOpportunityApprovalStatus__c = '草稿';
  opportunity.jdxspzt__c = '草稿';
  opportunity.CustomLevel__c = '公立三级';
  opportunity.Province__c = '北京市';
  opportunity.AccountNature__c = '公立医院';
    insert opportunity;

    Contract contract = new Contract();
  contract.AccountId = account.Id;
  contract.CurrencyIsoCode = 'CNY';
  //contract.OwnerId = '0056F0000082F6LQAU';
  contract.Status = 'Draft';
  contract.Opportunity__c = opportunity.Id;
  contract.contracttitle__c = '555';
  contract.Field1__c = false;     
    insert contract;    
        
    ConfigurationList__c configurationlist = new ConfigurationList__c();
  //configurationlist.OwnerId = '0056F0000082F6LQAU';
  configurationlist.Name = '333';
  configurationlist.CurrencyIsoCode = 'CNY';
  //configurationlist.RecordTypeId = '0126F000001UVaNQAW';
  configurationlist.Opportuniy__c = opportunity.Id;
  configurationlist.ContractReview__c = contract.Id;
    insert configurationlist;
    update contract;   
    
    }
}