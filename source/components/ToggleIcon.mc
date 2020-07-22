/**
 * Component for displaying various states using icons.
 *
 * Supports:
 *      Notifications
 *      Wi-fi connection
 *      Bluetooth connection
 *      Phone connection
 *      Do not disturb status
 */
class ToggleIcon extends Component {

    enum {
        NOT_DISPLAYED = -1,
        NOTIFICATIONS = 0,
        BLUETOOTH = 1,
        WIFI = 2,
        PHONE = 3,
        DO_NOT_DISTURB = 4,
    }

    private enum {
        UNSET = null,
        OFF = false,
        ON = true
    }

    private var iconIndex = 0;
    private var type = NOTIFICATIONS;
    private var status = UNSET;
    private var backgroundColor = Graphics.COLOR_WHITE;
    private var onColor = Graphics.COLOR_RED;
    private var offColor = Graphics.COLOR_LT_GRAY;
    private var font = null;
    private var iconWidth = 0;
    private var iconHeight = 0;

    private var iconCharacters = {
        NOTIFICATIONS => Icons.NOTIFICATIONS,
        WIFI => Icons.WIFI,
        BLUETOOTH => Icons.BLUETOOTH,
        PHONE => Icons.PHONE,
        DO_NOT_DISTURB => Icons.DO_NOT_DISTURB
    };

    function initialize(params) {
        Component.initialize(params);
        iconIndex = getParam(params, :index, 0);
        font = WatchUi.loadResource(Rez.Fonts.ICONS);
    }

    function getDoesSupportPartialUpdate() {
        return true;
    }

    function onLayout(dc) {
        Component.onLayout(dc);
        calculateIconDimens(dc);
    }

    function updateSettings(settings) {
        type = settings.iconType[iconIndex];
        status = UNSET;

        backgroundColor = settings.backgroundColor;
        onColor = settings.highlightColor;
        offColor = settings.secondaryGrayColor;
    }

    function onUpdate(dc) {
        status = getStatus();
        draw(dc);
    }

    function onPartialUpdate(dc) {
        var currentStatus = getStatus();
        if (currentStatus == status) {
            return;
        }        
        status = currentStatus;
        draw(dc);
    }

    function draw(dc) {            
        var color = status == ON ? onColor : offColor;
        dc.setColor(color, backgroundColor);
        dc.setClip(locX - (iconWidth / 2), locY, iconWidth, iconHeight);
        dc.clear();
        if (type != NOT_DISPLAYED) {
            dc.drawText(locX, locY, font, iconCharacters[type], Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    private function getStatus() {
        var deviceSettings = System.getDeviceSettings();
        switch (type) {
            case NOTIFICATIONS:
                return deviceSettings.notificationCount > 0;
            case BLUETOOTH:
                return getConnectionState(deviceSettings, :bluetooth) == System.CONNECTION_STATE_CONNECTED;
            case WIFI:
                return getConnectionState(deviceSettings, :wifi) == System.CONNECTION_STATE_CONNECTED;
            case PHONE:
                return deviceSettings.phoneConnected;
            case DO_NOT_DISTURB:
                return deviceSettings.doNotDisturb;
            default:
                return OFF;
        }
    }

    private function getConnectionState(deviceSettings, connection) {
        var info = deviceSettings.connectionInfo[connection];
        return info == null ? System.CONNECTION_STATE_NOT_INITIALIZED : info.state;
    }

    private function calculateIconDimens(dc) {
        var iconDimensions = dc.getTextDimensions(Icons.NOTIFICATIONS, font);
        iconWidth = iconDimensions[0];
        iconHeight = iconDimensions[1];
    }
}
