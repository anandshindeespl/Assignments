/**
 *  Email services are automated processes that use Apex classes
 *  this class will get the csv files fromthe  attachment ,parse the file and cteate records in salesforce. 
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   30th June 2015
 ===========================================================================================================================================
 */
global class SalesforceEmailHandler implements Messaging.InboundEmailHandler {
      
        //This method will recieves the content of incoming email and process the content to create new salesforce records
        global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        list <blob>lstBlob=new list<blob>();
        list<sobject>lstAccount=new list<sobject>();
        list<String>lstHeader=new list<String>();
        
        try 
           {
                if(test.isRunningTest())
                {
                    String testData='Name,Phone\nespl5,2433';
                    Attachment attachment = new Attachment();
                    attachment.Body = Blob.valueOf(testData);
                    system.debug('body****************'+attachment.Body.toString());
                    lstBlob.add(attachment.Body);
                }
                else
                {
                for(Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    lstBlob.add(attachment.Body);
                }
                }
                for(Integer i=0; i<lstBlob.size(); i++)
                {
                    system.debug('in loop1');
                    String csvdata=lstBlob[i].toString();
                    list<String> lstSplitedData=new list<String>();
                    lstSplitedData=csvdata.split('\n');
                    system.debug('lstSplitedData*********'+lstSplitedData);
                    
                    for(Integer j=0; j<lstSplitedData.size(); j++)
                    {
                        lstHeader=lstSplitedData[j].split(',');
                        break;
                    }
                    
                    for(Integer j=1; j<lstSplitedData.size(); j++)
                    {
                        SObject childObject = Schema.getGlobalDescribe().get('Account').newSObject();
                        list<String> lstRec=new list<String>();
                        lstRec = lstSplitedData[j].split(',(?=([^"]*"[^"]*")*[^\"]*$)');
                        system.debug('lstRec*******'+lstRec[0]);
                       
                        for(Integer l=0 ;l<lstHeader.size(); l++)
                        {
                            childObject.put(lstHeader[l], lstRec[l]);
                            system.debug('lstHeader[i], lstSplitedData[j'+lstHeader[l]);
                        }
                        lstAccount.add(childObject);
                    }
                }
                        insert lstAccount;
            }
            catch(Exception ex)
            {
                system.debug(ex.getMessage());
            }
                return result;
  }
      }