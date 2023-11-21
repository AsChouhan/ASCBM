public class TriggerHendler {
    public static Boolean recursive1 = true;
    List<Contact> updatelistDeleteRecord=new List<Contact>();
    public Integer deleteRecordSq=0;
    public Integer SN=0;
   	Map<Id, List<Contact>> newContactMap = new Map<Id, List<Contact>>();
    Map<Id, List<Contact>> existingContactMap = new Map<Id, List<Contact>>();
    Map<Integer, Contact> allContactMap = new Map<Integer, Contact>();
    List<Contact> invalidContacts = new List<Contact>();
    List<Contact>  updatedContactList = new List<Contact>();
    Set<Id> accId = new Set<Id>();
    public Integer range=0;
    
    public void insertion1(List<Contact> conlist){
        newContactMap.clear();
        existingContactMap.clear();
        allContactMap.clear();
        invalidContacts.clear();
        updatedContactList.clear();
        accId.clear();
        for (Contact c : conlist){
            accId.add(c.AccountId);
        }
         List<Account> accList = [SELECT Id, (SELECT Id, LastName,Sequence_Number__c, AccountId
                                             FROM Contacts
                                             WHERE Id NOT IN:conlist
                                             ORDER BY Sequence_Number__c)
                                 FROM Account 
                                 WHERE Id IN:accId];
        //trigger.new
        List<Contact> newConList = [SELECT Id, LastName, Sequence_Number__c, AccountId
                                    FROM Contact
                                    WHERE AccountId IN:accid AND Id IN:conlist];
        for (Contact c : newConList){
            if (!newContactMap.containsKey(c.AccountId)){
                newContactMap.put(c.AccountId, new List<Contact>{ c });
            } else{
                newContactMap.get(c.AccountId).add(c);
            }
        }
         System.debug('newContactMap --' + newContactMap);
        //existing
        for (Account acc : accList){
            existingContactMap.put(acc.Id, acc.Contacts);	
        }
         System.debug('existingContactMap-->>' + existingContactMap);
       for(Id acctId : accid){
            range = newContactMap.get(acctId).size() + existingContactMap.get(acctId).size();
            System.debug('range  => ' + range);
            for(Contact cont : newContactMap.get(acctId)){
                if(cont.Sequence_Number__c < 1 || cont.Sequence_Number__c > range || cont.Sequence_Number__c == Null){
                    invalidContacts.add(cont);
                    System.debug('if');
                }
                else if(allContactMap.containsKey((Integer)cont.Sequence_Number__c)){
                    System.debug(' else if');
                    Integer k = (Integer)cont.Sequence_Number__c+1;
                    while(allContactMap.containsKey(k)){
                        k++;
                    }
                    System.debug('k----------->>'+k);
                    for(Integer i=k; i>cont.Sequence_Number__c; i--){
                        if(i<=range){
                            allContactMap.put(i,allContactMap.get(i-1));
                            allContactMap.get(i).Sequence_Number__c++;
                        }
                        else{
                            invalidContacts.add(allContactMap.get(i-1));
                        }
                    }
                }
                allContactMap.put((Integer)cont.Sequence_Number__c,cont);
            }System.debug('allContactMap before before=> ' + allContactMap);
            for(Contact cct : existingContactMap.get(acctId)){
                if(!allContactMap.containsKey((Integer)cct.Sequence_Number__c)){
                    allContactMap.put((Integer)cct.Sequence_Number__c,cct);
                }
                else{
                    Integer j= 1;
                    //existing
                    while(j<=range){
                        if(!allContactMap.containsKey(j)){
                            allContactMap.put(j,cct);
                            allContactMap.get(j).Sequence_Number__c= j;
                            break;
                        }
                        j++;
                    }
                }  
            }
            System.debug('allContactMap before=> ' + allContactMap);
            for(Contact cnt : invalidContacts){	
                Integer k= 1;
                //invalid
                while(k<=range){
                    if(!allContactMap.containsKey(k)){
                        allContactMap.put(k,cnt);
                        System.debug('allContactMap inside => ' + allContactMap);
                        allContactMap.get(k).Sequence_Number__c= k;
                        break;
                    }
                    k++;
                }
            }
        }
        for(Integer i = 1;i<=range;i++){
            updatedContactList.add(allContactMap.get(i));
        }
        System.debug('allContactMap => ' + allContactMap);
        
        
        recursive1 = false;
        update updatedContactList;
        recursive1 = true;
      
         
    }
    
     public void deleteRecord(List<Contact> listOfoldRecord){
        map<id,List<Contact>> mapOfAllRecord = new map<id,List<Contact>>();
        set<id> idOfAccounts=new set<id>();
        List<Contact> contactList=new List<Contact>();
         For(Contact c:listOfoldRecord){
                idOfAccounts.add(c.AccountId);
            }
        contactList=[SELECT id,Name,Sequence_Number__c,Accountid FROM Contact WHERE Accountid in :idOfAccounts order by Sequence_Number__c];
        for(Contact c : contactList){
            if(!mapOfAllRecord.containsKey(c.AccountId)){
                mapOfAllRecord.put(c.AccountId,new List<Contact>());
            }
            if(c.AccountId!=null){
            mapOfAllRecord.get(c.AccountId).add(c);
            }
        }
        /*RecordList=[SELECT id,Name,Sequence_Number__c,Accountid FROM Contact WHERE AccountId=:idOfAccounts];
        deleteRecordSq=1;
        for(Contact ct: RecordList){
            ct.Sequence_Number__c=deleteRecordSq;
            updatelistDeleteRecord.add(ct);
            deleteRecordSq++;
        }*/
        
        for(id acctId : mapOfAllRecord.keySet()){
            deleteRecordSq = 1;
            for(Contact ct : mapOfAllRecord.get(acctId)){
                ct.Sequence_Number__c = deleteRecordSq;
                updatelistDeleteRecord.add(ct);
                deleteRecordSq++;
            }
        }
        update updatelistDeleteRecord;
    }
    public void undeleteRecord(List<Contact> listOfUnDeleteRecord){
        List<Contact> UpdateListofUndeleteRecord=new List<Contact>();
        updatelistDeleteRecord.clear();
        set<Id> unDeleteRecordAccountid= new set<Id>();
        List<Contact> ContactList=new List<Contact>();
        map<Id,List<Contact>> mapOfundeleteRecord = new map<Id,List<Contact>>();
        
        For(Contact c:listOfUnDeleteRecord){
            unDeleteRecordAccountid.add(c.AccountId);
        }
        ContactList=[SELECT id,Name,Sequence_Number__c,AccountId FROM Contact WHERE AccountId=:unDeleteRecordAccountid AND Id=:listOfUnDeleteRecord];
        
        UpdateListofUndeleteRecord=[SELECT id,Name,Sequence_Number__c,AccountId FROM Contact WHERE AccountId=:unDeleteRecordAccountid];
        
        for(Contact c : ContactList){
            if(!mapOfundeleteRecord.containsKey(c.AccountId)){
                mapOfundeleteRecord.put(c.AccountId,new List<Contact>());
            }
            if(c.AccountId!=null){
                mapOfundeleteRecord.get(c.AccountId).add(c);
            }
        }
        Integer size=0;
        for(id acctId : mapOfundeleteRecord.keySet()){
            size=UpdateListofUndeleteRecord.size();
            for(Contact ct : mapOfundeleteRecord.get(acctId)){
                ct.Sequence_Number__c=size;
                updatelistDeleteRecord.add(ct);
                size++;
            }
        }
        /*for(Contact ct:updatelistDeleteRecord){
            UpdateListofUndeleteRecord.add(ct);
        }*/
        update updatelistDeleteRecord;
    }
    public void updateRecord(map<Id, Contact> newRecordmap , map<Id,Contact> oldContact , List<Contact> newRecordList, List<Contact> oldRecordList){ 
        
        set<id> AccId = new set<id>(); 
        set<Id> conId = new Set<Id>(); 
        
        /*List<Contact> updatedContact=new List<Contact>();
        List<Contact> invalidSequenceNumber = new List<Contact>(); 
        List<Contact> validSequenceNumber = new List<Contact>(); 
        //List<Contact> updatelistofcontact = new List<Contact>();*/
        List<Contact> existingContact = new List<Contact>();
        List <Contact> updateList = new List<Contact>();       
        map<Id, List<Contact>> mapOfexistingContact = new  map<Id, List<Contact>>(); 
        map<id, Contact> mapOfNewUpdatedContact = new Map<id, Contact>(); 
        //mapOfNewUpdatedContact.clear();
        updateList.clear();
        mapOfexistingContact.clear();
        for(Contact c:newRecordList){ 
            conId.add(c.Id); 
            AccId.add(c.AccountId); 
        } 
		
		Boolean reparent = false;
		Set<ID> oldAccID = new Set<ID>();
		for(Contact cnt : oldRecordList){
			if(!accId.contains(cnt.AccountId)){
				oldAccID.add(cnt.AccountId);
				reparent = true;
			}
		}
		
        existingContact  = [SELECT Id, LastName, Sequence_Number__c, AccountId 
                            FROM Contact WHERE AccountId IN:AccId  AND Id NOT IN:conId Order By Sequence_Number__c]; 
        
        List<Contact> newRecords=[SELECT Id, LastName, Sequence_Number__c, AccountId 
                                  FROM Contact WHERE AccountId IN:AccId AND Id IN:conId]; 
        
        for(Contact c : existingContact){
            if(!mapOfexistingContact.containsKey(c.AccountId)){
                mapOfexistingContact.put(c.AccountId,new List<Contact>());
            }
            if(c.AccountId!=null){
                c.Sequence_Number__c = mapOfexistingContact.get(c.AccountId).size()+1;
                mapOfexistingContact.get(c.AccountId).add(c);
            }
        }
        Integer Size=0;
        for(Contact c : newRecords){
            Size=mapOfexistingContact.get(c.AccountId).size();
            Integer oldSequencenum = (Integer)oldContact.get(c.Id).Sequence_Number__c;
            Integer newSequencenum = (Integer)c.Sequence_Number__c;   
            if(c.Sequence_Number__c == null || c.Sequence_Number__c > mapOfexistingContact.get(c.AccountId).size() || c.Sequence_Number__c < 1){
                /*for(Contact ct :mapOfexistingContact.get(c.AccountId)){
                    if(ct.Sequence_Number__c > oldsequencenum ){
                        ct.Sequence_Number__c -=1;
                    }
                }*/
                 c.Sequence_Number__c=Size+1;
                // mapOfNewUpdatedContact.put(c.Sequence_Number__c,c);
                mapOfexistingContact.get(c.AccountId).add(c);
               
            }
            else{
                if(oldSequencenum < newSequencenum){
                    for(Integer i=oldSequencenum-1; i<newSequencenum; i++){
                        if(mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c <= newSequencenum && oldSequencenum <= mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c){
                            mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c-=1;
                            // mapOfNewUpdatedContact.put(mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c, mapOfexistingContact.get(c.AccountId).get(i));   
                        }
                    }
                }
                else{
                    for(Integer i=newSequencenum-1; i<oldSequencenum-1; i++){
                        if(mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c >= newSequencenum && oldSequencenum >= mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c){
                          //System.debug('hello i am else');
                            mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c+=1;
                            // mapOfNewUpdatedContact.put(mapOfexistingContact.get(c.AccountId).get(i).Sequence_Number__c, mapOfexistingContact.get(c.AccountId).get(i));   
                        }
                    }
                }
                mapOfexistingContact.get(c.AccountId).add(c);
            }
        }
        Map<Id,List<Contact>> reparentMap = new Map<Id,List<Contact>>();
		if(reparent == true){
			List<Contact> existingReparentingConList = [SELECT ID, AccountId, Sequence_Number__c FROM Contact WHERE AccountId IN :oldAccID ORDER BY Sequence_Number__c];
			for(Contact c : existingReparentingConList){
				if(!reparentMap.containsKey(c.AccountId)){
                	reparentMap.put(c.AccountId, new List<Contact>());
				}
				c.Sequence_Number__c = reparentMap.get(c.AccountId).size()+1;
                reparentMap.get(c.AccountId).add(c);  
           }

		}
        for(Id acc: mapOfexistingContact.keySet()){
         	for(Contact con: mapOfexistingContact.get(acc)){
            	if(con.AccountId != null){
                	updateList.add(con);
            	}
        	}   
        }
		if(reparent == true){
			for(Id acc: reparentMap.keySet()){
				for(Contact con: reparentMap.get(acc)){
					if(con.AccountId != null){
						updateList.add(con);
					}
				}   
			}
		}
        recursive1 = false;
        update updateList;
    }
}