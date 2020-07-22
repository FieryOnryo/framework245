using Toybox.WatchUi;

/**
 * Base class for components. All components should extend from this class.
 */
class Component extends WatchUi.Drawable {

    protected var xPercent = 0;
    protected var yPercent = 0;
    protected var screenDiameter = 0;

    /**
     * Loads the relative positioning that components should utilize.
     */
    function initialize(params) {
        Drawable.initialize(params);
        xPercent = getParam(params, :xPercent, 0);
        yPercent = getParam(params, :yPercent, 0);
    }

    /**
     * Override this and return true if the component will support partial updates.
     */
    function getDoesSupportPartialUpdate() {
        return false;
    }

    /**
     * When the layout is loaded, set the pixel position of the component based on the screen size.
     */
    function onLayout(dc) {
        screenDiameter = dc.getWidth();
        locX = screenDiameter * xPercent / 100;
        locY = screenDiameter * yPercent / 100;
    }

    /**
     * Called when the app state is changed.
     */
    function updateAppState(appState) {
    }

    /**
     * Called when the settings are updated.
     */
    function updateSettings(settings) {
        printWarning("updateSettings(settings)");
    }

    /**
     * Called when the watchface onUpdate occurs.
     */
    function onUpdate(dc) {
        printWarning("onUpdate(dc)");
    }

    /**
     * Called when the watchface onPartialUpdate occurs for components that support partial updates.
     */
    function onPartialUpdate(dc) {
        printWarning("onPartialUpdate(dc)");
    }

    /**
     * Helper function for loading parameters from the layout.
     */
    protected function getParam(params, key, defaultValue) {
        return params.hasKey(key) ? params[key] : defaultValue;
    }

    /**
     * Helper function for printing a warning that a function hasn't been overriden
     * when it is expected that the component will be required to do so.
     *
     * If a component does not need the function, override with an empty function to
     * avoid the overhead of this warning being printed!
     */
    private function printWarning(name) {
        System.println("Warning: " + name + " not implemented!");
    }
}
