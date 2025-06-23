@isTest
private class ICS_BaseException_tst {
    @isTest
    static void test_exception_instantiation_and_throwing() {
        Boolean exceptionThrown = false;
        try{
            throw new ICS_BaseException('Test exception message');
        }catch (ICS_BaseException ex) {
            exceptionThrown = true;
            Assert.areEqual('Test exception message', ex.getMessage(), 'The exception message should match the one provided during instantiation');
        }
        Assert.areEqual(true, exceptionThrown, 'ICS_BaseException should have been thrown and caught');
    }
}