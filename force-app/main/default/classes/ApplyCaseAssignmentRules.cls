public class ApplyCaseAssignmentRules
{
    @InvocableMethod (label='Apply Case Assignment Rules')
    public static void CaseAssign(List<Id> CaseId)
    {
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;
            dmo.EmailHeader.TriggerUserEmail = true;                
            Case Cases=[Select id From Case Where Case.id in:CaseId];
            Cases.setOptions(dmo);
            update Cases;
   }
}