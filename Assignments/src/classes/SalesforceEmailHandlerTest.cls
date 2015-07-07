/**
 *  Email services are automated processes that use Apex classes
 *  this class will get the csv files fromthe  attachment ,parse the file and cteate records in salesforce. 
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   1st July 2015
 ===========================================================================================================================================
 */
@isTest
private class SalesforceEmailHandlerTest {
    
    static testMethod void myUnitTest() {
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        Test.startTest(); 
        SalesforceEmailHandler emailhandler = new SalesforceEmailHandler();
        Messaging.InboundEmailResult result = emailhandler.handleInboundEmail(email, envelope);
        list<Account>acclist=[select Id,Name from Account where Name='espl5'];
        system.assertEquals(1,acclist.size());
        system.assertEquals(result.success, true);
        Test.stopTest();
    }
}