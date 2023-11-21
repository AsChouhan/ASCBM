public with sharing class SkillBasedRouting {
    @InvocableMethod 
    public static void rountingCaseToAgent(List<String> CaseIds){
        List<case> caseInserted = [SELECT Id, Subject FROM Case WHERE ID IN : CaseIds];
        List<Skill> allSkill = [SELECT Id, MasterLabel FROM Skill];
        
        for(case casePSR : caseInserted){
            PendingServiceRouting psr = new PendingServiceRouting();
            psr.workItemId = casePSR.id;
            psr.RoutingType = 'SkillsBased';
            psr.RoutingPriority = 1;
            psr.capacityWeight = 1;
            psr.ServiceChannelId = '0N95g000000cUD6';
            psr.RoutingModel = 'MostAvailable';
            psr.IsReadyForRouting = FALSE;
            Insert psr;

            //find out the Skill Required for a five case based on its Subject
            List<String> matchingSkillIds = new List<String>();
                for(Skill skillR : allSkill){
                    if(casePSR.Subject.contains(skillR.MasterLabel)){
                        matchingSkillIds.add(skillR.Id);
                    }
                }

            List<SkillRequirement> SkillToInsert = new List<SkillRequirement>();
            //Associate matching skills with PSR request
            for(String matchingSkillId : matchingSkillIds){
                SkillRequirement skillReq = new SkillRequirement();
                skillReq.SkillId = matchingSkillId;
                skillReq.RelatedRecordId = psr.id;
                skillReq.SkillLevel = 5;
                SkillToInsert.add(skillReq);
            }
            Insert SkillToInsert;

            psr.IsReadyForRouting = TRUE;
            update psr;
        }
    }
}