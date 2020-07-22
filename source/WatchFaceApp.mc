using Toybox.Application;

/**
 * Class for initializing the watchface and handling settings updates.
 */
class WatchFaceApp extends Application.AppBase {

    private var watchFace = null;

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        watchFace = new WatchFaceView();
        return [watchFace, watchFace.DELEGATE];
    }

    function onSettingsChanged() {
        watchFace.updateSettings();
    }
}
