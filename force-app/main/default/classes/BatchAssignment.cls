public class BatchAssignment implements Database.Batchable<sobject>,Database.Stateful,schedulable{
    public String CSVFile='Name , Birthdate , Description ,LastCURequestDate , DoNotCall,\n';
    public Database.QueryLocator start(Database.BatchableContext bc){
        	return Database.getQueryLocator('SELECT  FirstName,Status__c,Birthdate,Description,LastCURequestDate,DoNotCall FROM Contact WHERE Createddate = yesterday');
        	
    }
    public void execute(Database.BatchableContext bc,List<Contact> conList){
        for(Contact c: conList){
            c.Status__c='Ready for approved';
            CSVFile+=c.FirstName+',';
            CSVFile+=c.Birthdate+',';
            CSVFile+=c.Description.escapecsv()+',';
            CSVFile+=c.LastCURequestDate+',';
            CSVFile+=c.DoNotCall+','+'\n';
        }
        
       // System.debug(CSVFile);
        update conList;
    }
    public void finish(Database.BatchableContext bc){
        			//System.debug(CSVFile);
                 Messaging.EmailFileAttachment csvattach = new Messaging.EmailFileAttachment();
                 blob csvBlob = Blob.valueOf(CSVFile);
                 string csvname = 'ReadyForApproval.csv';
                 csvattach.setFileName(csvname);
                 csvattach.setBody(csvBlob);
                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                  String[] mailAddress = new list<string>{'bsofficial20@gmail.com'};
                  email.setSubject('Updated Contact CSV');
                  email.setToAddresses( mailAddress );
                  email.setPlainTextBody( 'Please Find the attached CSV file of updated contacts'); 
                  email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvattach});
                  Messaging.SendEmailResult [] res = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        			//System.debug('email-->'+email);
    }
    public void execute(schedulablecontext sc){
        BatchAssignment kp = new BatchAssignment();
       Id batchId=Database.executeBatch(kp);
    }
}