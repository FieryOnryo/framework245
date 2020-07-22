using Toybox.WatchUi;

/**
 * Component for displaying battery percentage text and icon.
 */
class BatteryIcon extends Component {

    private var batteryHighlightColor = Graphics.COLOR_RED;
    private var batteryBackgroundColor = Graphics.COLOR_RED;
    private var textColor = Graphics.COLOR_BLACK;
    private var backgroundColor = Graphics.COLOR_BLACK;
    private var batteryIconOffset = 8;
    private var font = null;
    private var clipWidth = 0;
    private var clipHeight = 0;

    function initialize(params) {
        Component.initialize(params);
        font = WatchUi.loadResource(Rez.Fonts.BATTERY);        
    }

    function onLayout(dc) {
        Component.onLayout(dc);
        calculateClipDimensions(dc);
    }

    function updateSettings(settings) {
        textColor = settings.foregroundColor;
        backgroundColor = settings.backgroundColor;
        batteryHighlightColor = settings.highlightColor;   
        batteryBackgroundColor = settings.secondaryGrayColor;
    }

    function onUpdate(dc) {    
        var batteryLevel = (System.getSystemStats().battery + 0.5).toNumber();        
        var batteryLevelText = batteryLevel + "%";

        dc.setClip(locX - (clipWidth / 2), locY + batteryIconOffset, clipWidth, clipHeight);
        dc.setColor(batteryBackgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY + batteryIconOffset, font, Icons.BATTERY, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setClip(locX - (clipWidth / 2), locY + batteryIconOffset, clipWidth * batteryLevel / 100, clipHeight);
        dc.setColor(batteryHighlightColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY + batteryIconOffset, font, Icons.BATTERY, Graphics.TEXT_JUSTIFY_CENTER);

        dc.clearClip();
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY, Graphics.FONT_SYSTEM_XTINY, batteryLevelText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function calculateClipDimensions(dc) {
        var dimensions = dc.getTextDimensions(Icons.BATTERY, font);
        clipWidth = dimensions[0];
        clipHeight = dimensions[1];
    }
}
