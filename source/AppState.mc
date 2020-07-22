/**
 * Class for holding possible app states and associated helper functions.
 */
class AppState {

	static const ACTIVE = new AppState();
	static const SLEEP = new AppState();
	static const DEEP_SLEEP = new AppState();
	static const POWER_BUDGET_EXCEEDED = new AppState();

    function getIsSleep() {
        return self == SLEEP;
    }

    function getIsDeepSleep() {
        return self == DEEP_SLEEP || self == POWER_BUDGET_EXCEEDED;
    }

    function getIsPowerBudgetExceeded() {
        return self == POWER_BUDGET_EXCEEDED;
    }
}
