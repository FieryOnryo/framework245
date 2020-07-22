using Toybox.Application.Properties;

/**
 * Data class for loading the current watchface settings from the system.
 *
 * Also see properties.xml and settings.xml.
 */
class Settings {

    const DEEP_SLEEP_OFF = -1;

    private const DARK_MODE = "isDarkModeEnabled";
    private const HIGHLIGHT_COLOR = "highlightColor";
    private const DEEP_SLEEP_TIMEOUT_SECONDS = "deepSleepTimeoutSeconds";
    private const HEART_RATE_REFRESH_FREQUENCY = "heartRateRefreshFrequency";
    private const SECONDS_MARK = "isSecondsMarkEnabled";
    private const ICON_TYPE = "iconType";
    private const ICON_TYPE_0 = ICON_TYPE + "0";
    private const ICON_TYPE_1 = ICON_TYPE + "1";
    private const DATA_TYPE = "dataType";
    private const DATA_TYPE_0 = DATA_TYPE + "0";
    private const DATA_TYPE_1 = DATA_TYPE + "1";
    private const LAYOUT_INDEX = "layoutIndex";

    const isDarkModeEnabled = loadProperty(DARK_MODE, false, Boolean);
    const isSecondsMarkEnabled = loadProperty(SECONDS_MARK, true, Boolean);
    const deepSleepTimeoutSeconds = loadProperty(DEEP_SLEEP_TIMEOUT_SECONDS, 15, Number);
    const heartRateRefreshFrequency = loadProperty(HEART_RATE_REFRESH_FREQUENCY, 5, Number);
    const layoutIndex = loadProperty(LAYOUT_INDEX, 0, Number);

    const backgroundColor = isDarkModeEnabled ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE;
    const foregroundColor = isDarkModeEnabled ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
    const mainGrayColor = isDarkModeEnabled ? Graphics.COLOR_LT_GRAY : Graphics.COLOR_DK_GRAY;
    const secondaryGrayColor = isDarkModeEnabled ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_LT_GRAY;     
    const highlightColor = loadProperty(HIGHLIGHT_COLOR, Graphics.COLOR_RED, Number);

    const iconType = [
        loadProperty(ICON_TYPE_0, ToggleIcon.NOTIFICATIONS, Number),
        loadProperty(ICON_TYPE_1, ToggleIcon.BLUETOOTH, Number)
    ];

    const dataType = [
        loadProperty(DATA_TYPE_0, DataField.STEPS, Number),
        loadProperty(DATA_TYPE_1, DataField.TOTAL_CALORIES, Number)
    ];

    private function loadProperty(name, defaultValue, type) {
        var value = Properties.getValue(name);
        if (value == null || !(value instanceof type)) {
            value = defaultValue;
        }
        return value;
    }
}
