using Toybox.Time.Gregorian;

/**
 * Component for displaying the time as HH:MM.
 */
class HourAndMinute extends Component {

    private const SEPARATOR = ":";

    private var backgroundColor = Graphics.COLOR_WHITE;
    private var textColor = Graphics.COLOR_BLACK;
    private var separatorColor = Graphics.COLOR_DK_GRAY;
    private var xOffset = 0;
    private var yOffset = 0;

    function initialize(params) {
        Component.initialize(params);
    }

    function onLayout(dc) {
        Component.onLayout(dc);
        xOffset = screenDiameter * 0.05;
        yOffset = screenDiameter * 0.02;        
    }

    function updateSettings(settings) {
        textColor = settings.foregroundColor;
        separatorColor = settings.mainGrayColor;
        backgroundColor = settings.backgroundColor;
    }

    function onUpdate(dc) {
        var timeInfo = Gregorian.info(Time.now(), Time.FORMAT_LONG);    

        dc.clearClip();
        dc.setColor(separatorColor, backgroundColor);
        dc.drawText(
            locX,
            locY - yOffset,
            Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
            SEPARATOR,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        var hour = System.getDeviceSettings().is24Hour ? timeInfo.hour : get12HourTime(timeInfo.hour);
        dc.setColor(textColor, backgroundColor);
        dc.drawText(
            locX - xOffset,
            locY,
            Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
            hour.format("%02d"),
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        dc.drawText(
            locX + xOffset,
            locY,
            Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
            timeInfo.min.format("%02d"),
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
    
    private function get12HourTime(hour) {
        return hour > 12 ? hour - 12 : hour == 0 ? 12 : hour;
    }
}
