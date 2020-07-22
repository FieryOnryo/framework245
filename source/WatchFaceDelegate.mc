using Toybox.WatchUi;

/**
 * Delegate class for triggering a callback when power budget is exceeded.
 */
class WatchFaceDelegate extends WatchUi.WatchFaceDelegate {

    var onPowerBudgetExceededCallback = null;

    function initialize(callback) {
        WatchFaceDelegate.initialize();
        onPowerBudgetExceededCallback = callback;
    }

    function onPowerBudgetExceeded(powerInfo) {
        System.println( "Average execution time: " + powerInfo.executionTimeAverage );
        System.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
        onPowerBudgetExceededCallback.invoke();
    }
}
