global with sharing class CreateMAQFromOpp
{
//added code to test git change
Webservice static string createMAQ(Id oppId){

    try{
        Opportunity newOpp = [Select Name, ownerid, Account.Name, Account.Phone, Est_Annual_Salesc__c, Est_Average_Ticketc__c, Current_Processsor__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
        User oppOwner = [select id, email, name, firstname, lastname from User where id = :newOpp.ownerid] ;
        
        Account acct = [Select Id, Phone, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode FROM Account where Name = :newOpp.Account.Name LIMIT 1];
        ID rectypeID = [Select Id, name from RecordType where name = 'MAQ Edit' and SobjectType='Merchant_Application_Questionnaire__c'].id;
        Merchant_Application_Questionnaire__c maqIns = new Merchant_Application_Questionnaire__c();
        maqIns.Name__c = newOpp.Account.Name;       
        maqIns.Est_Annual_Sales__c= newOpp.Est_Annual_Salesc__c;
        maqIns.Est_Average_Ticket__c = newOpp.Est_Average_Ticketc__c;
        maqIns.Opportunity__c = newOpp.Id;
        maqIns.Current_Processor_Name__c = newOpp.Current_Processsor__c;
       
        maqIns.Account__c = acct.Id;
        maqIns.Phone__c = acct.Phone;
        maqIns.Business_Address__c = acct.BillingStreet;
        maqIns.City__c = acct.BillingCity;
        maqIns.State_Province__c= acct.BillingState;
        maqIns.Country__c = acct.BillingCountry;
        maqIns.Zip_Postal_Code__c = acct.BillingPostalCode;
        maqIns.RecordTypeId = rectypeID;
        maqIns.Opportunity_Owner_Email__c = oppOwner.email;
        maqIns.Opportunity_Owner_Fullname__c = oppOwner.FirstName + ' ' + oppOwner.LastName;
        insert maqIns;
        Id maqId = String.valueOf(maqIns.Id); 
        
        return String.valueOf(maqId);
                
   }catch(DMLException e){
             return e.getMessage();
      }        
   return null;
   
}
}