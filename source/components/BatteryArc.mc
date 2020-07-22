using Toybox.WatchUi;

/**
 * Component for displaying battery percentage text and arc.
 */
class BatteryArc extends Component {

    private var arcX = 0;
    private var arcY = 0;
    private var arcRadius = 0;
    private var clipOffsetY = 0;
    private var penWidth = 0;
    private var arcBackgroundColor = Graphics.COLOR_DK_GRAY;
    private var arcHighlightColor = Graphics.COLOR_RED;
    private var textColor = Graphics.COLOR_BLACK;
    private var backgroundColor = Graphics.COLOR_BLACK;

    function initialize(params) {
        Component.initialize(params);
    }

    function onLayout(dc) {
        Component.onLayout(dc);
        arcX = locX;
        arcY = locY * 0.7;
        arcRadius = screenDiameter * 0.13;
        clipOffsetY = screenDiameter * 0.03;
        penWidth = screenDiameter * 0.015; 
    }

    function updateSettings(settings) {
        textColor = settings.foregroundColor;
        backgroundColor = settings.backgroundColor;
        arcBackgroundColor = settings.mainGrayColor;
        arcHighlightColor = settings.highlightColor;   
    }

    function onUpdate(dc) {    
        var batteryLevel = (System.getSystemStats().battery + 0.5).toNumber();
        dc.clearClip();
        drawBatteryText(dc, batteryLevel);
        drawBatteryArc(dc, batteryLevel);
    }

    private function drawBatteryText(dc, batteryLevel) {
        var batteryString = batteryLevel + "%";
        dc.setColor(textColor, backgroundColor);
        dc.drawText(locX, locY, Graphics.FONT_XTINY, batteryString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawBatteryArc(dc, batteryLevel) {
        dc.setPenWidth(penWidth);
        dc.setColor(arcBackgroundColor, backgroundColor);
        dc.drawArc(arcX, arcY, arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, 200, -20);
        dc.setColor(arcHighlightColor, backgroundColor);
        dc.drawArc(arcX, arcY, arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, 200, 200 + (140 * batteryLevel / 100));        
    }
}
