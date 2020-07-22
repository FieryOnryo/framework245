using Toybox.WatchUi;

/**
 * Class for loading the watchface layout and managing component behavior.
 *
 * This watchface supports 3 levels of power usage:
 *      ACTIVE - High power mode
 *      SLEEP - Low power mode
 *      DEEP_SLEEP - Low power mode with single update on entering this state (allowing components
 *                   to update for the state change) then no partial updates occuring.
 */
class WatchFaceView extends WatchUi.WatchFace {
    
    const DELEGATE = new WatchFaceDelegate(method(:onPowerBudgetExceeded));

    private const DEBUG_RENDER_WATCH_MARKS_FOR_BITMAP = false;

    private var allComponents = [];
    private var partialUpdateComponents = [];

    private var appState = AppState.ACTIVE;
    private var deepSleepTimeoutSeconds = 15;
    private var shouldSkipPartialUpdate = false;
    private var secondsSleeping = 0;
    private var shouldReloadLayout = false;
    private var layoutIndex = 0;

    function initialize() {
        WatchFace.initialize();
        updateSettings();   
    }

    function updateSettings() {
        var settings = new Settings();

        deepSleepTimeoutSeconds = settings.deepSleepTimeoutSeconds;

        var newLayoutIndex = settings.layoutIndex;
        shouldReloadLayout = newLayoutIndex != layoutIndex;
        layoutIndex = newLayoutIndex;

        if (deepSleepTimeoutSeconds == Settings.DEEP_SLEEP_OFF && appState.getIsDeepSleep()) {
            setAppState(AppState.SLEEP);
        }

        updateComponentSettings(settings);
        requestUpdate();
    }

    function onLayout(dc) {        
        loadLayout(dc);                
    }

    function loadLayout(dc) {
        var layoutOrDebugIndex = DEBUG_RENDER_WATCH_MARKS_FOR_BITMAP ? LayoutManager.WATCH_MARKS_DEBUG : layoutIndex;
        allComponents = LayoutManager.getComponents(dc, layoutOrDebugIndex);

        partialUpdateComponents = [];

        for (var i = 0; i < allComponents.size(); i++) {
            var component = allComponents[i];
            if (component.getDoesSupportPartialUpdate()) {
                partialUpdateComponents.add(component);
            }
            component.onLayout(dc);
        }
        
        updateComponentSettings(new Settings());
        updateComponentAppState();
    }

    function updateComponentSettings(settings) {
        for (var i = 0; i < allComponents.size(); i++) {
            allComponents[i].updateSettings(settings);            
        }
    }
    
    function onUpdate(dc) {
        if (shouldReloadLayout) {
            loadLayout(dc);
            shouldReloadLayout = false;
        }

        checkSleepState();
        for (var i = 0; i < allComponents.size(); i++ ) {
            allComponents[i].onUpdate(dc);
        }
    }

    function onPartialUpdate(dc) {
    	/* As a large amount of time will be spent in deep sleep, we want to minimize as much 
    	 * overhead as possible. By using a boolean rather than checking appState, we reduce 
    	 * our run time from 143us to a mere 43us while in deep sleep.
    	 */
        if (shouldSkipPartialUpdate) {
            return;
        }

        checkSleepState();
        for (var i = 0; i < partialUpdateComponents.size(); i++ ) {
            partialUpdateComponents[i].onPartialUpdate(dc);
        }
    }

    // We can't use a timer as the system stops them in low power mode, so manually track the time.
    function checkSleepState() {
        if (deepSleepTimeoutSeconds != Settings.DEEP_SLEEP_OFF && appState.getIsSleep()) {
            secondsSleeping++;
            if (secondsSleeping > deepSleepTimeoutSeconds) {
                setAppState(AppState.DEEP_SLEEP);
            }
        }
    }

    private function setAppState(newAppState) {
        if (appState.getIsPowerBudgetExceeded()) {
        	// If the power budget has been blown, only minute updates occur until
        	// the watchface is reloaded, so do not allow the state to change.
            return;
        }

    	appState = newAppState;
    	shouldSkipPartialUpdate = appState.getIsDeepSleep();
    	secondsSleeping = 0;
    	updateComponentAppState();

    	requestUpdate();
    }

    private function updateComponentAppState() {
        for (var i = 0; i < allComponents.size(); i++) {
           allComponents[i].updateAppState(appState);
        }
    }

    function onExitSleep() {
        setAppState(AppState.ACTIVE);
    }

    function onEnterSleep() {
        setAppState(AppState.SLEEP);
    }

    function onPowerBudgetExceeded() {
        setAppState(AppState.POWER_BUDGET_EXCEEDED);
    }
}
