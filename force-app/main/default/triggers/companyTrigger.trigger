trigger companyTrigger on Employee__c (before insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            System.debug('trigger comes');
            Map<Id, List<Employee__c>> empMap = new Map<Id, List<Employee__c>>();
            for(Employee__c emp : Trigger.new){
                System.debug(emp);
                if(!empMap.containsKey(emp.Company__c)){
                    empMap.put(emp.Company__c, new List<Employee__c>());
                }
                empMap.get(emp.Company__c).add(emp);
            }
            System.debug('map here');
            for(Id ids : empMap.keySet()){
                System.debug(ids+'   ->   '+empMap.get(ids).size());                
            }
            List<Company__c> cc = [select name, Total_Amount__c, (select name, Salary__c, Company__c from Employes__r) from Company__c where id in : empMap.keySet()];
            System.debug(cc.size());
            for(Company__c com : cc){
                Decimal totalAmount = com.Total_Amount__c;
                Decimal empAmount = 0;

                for(Employee__c em : com.Employes__r){
                    empAmount+=em.Salary__c;
                }
                System.debug(empAmount+'   '+totalAmount);
                for(Employee__c em1 : empMap.get(com.Id)){
                    Decimal currentTotalAmount = empAmount+em1.Salary__c;
                    System.debug(currentTotalAmount);
                    if(totalAmount < currentTotalAmount){
                        em1.Salary__c.addError('total salary amount reached');
                    }
                }
            }

        }
    }
}