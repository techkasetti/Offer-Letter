@IsTest
public class ZoomMetingScheduleTest {
    @IsTest(seeAllData=false)
    public static void ZoomMetingScheduleTest1() {
        
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockGenerator());
        ZoomMetingSchedule.scheduleMeeting();
        System.Test.StopTest();
    }
}