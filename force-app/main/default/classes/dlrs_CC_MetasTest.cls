/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_CC_MetasTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_CC_MetasTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new CC_Metas__c());
    }
}