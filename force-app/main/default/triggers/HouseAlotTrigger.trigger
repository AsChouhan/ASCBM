trigger HouseAlotTrigger on People__c (after insert) {
	// Getting all Houses...
	List<House__c> houseList = [select name from House__c];
    List<People__c> peopleList = [select name from People__c];

    
    for(integer i=0;i<peopleList.size();i++){
        for(Integer j=0;j<houseList.size();j++){
            if(i != peopleList.size()){
                peopleList[i].House__c = houseList[j].Id;
                i++;
            }
        }
    }
    update peopleList;
}