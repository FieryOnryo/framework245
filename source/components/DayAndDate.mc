using Toybox.Time.Gregorian;

/**
 * Component for displaying the day of the week and date.
 */
class DayAndDate extends Component {

    private var backgroundColor = Graphics.COLOR_WHITE;
    private var dayOfTheMonthColor = Graphics.COLOR_BLACK;
    private var textColor = Graphics.COLOR_DK_GRAY;
    private var xOffset = 0;
    private var yOffset = 0;

    function initialize(params) {
        Component.initialize(params);
    }

    function onLayout(dc) {
        Component.onLayout(dc);

        yOffset = (dc.getFontHeight(Graphics.FONT_MEDIUM) - dc.getFontHeight(Graphics.FONT_TINY)) / 2 * 1.25;
        xOffset = screenDiameter * 0.09;
    }

    function updateSettings(settings) {
        dayOfTheMonthColor = settings.foregroundColor;
        textColor = settings.mainGrayColor;
        backgroundColor = settings.backgroundColor;
    }

    function onUpdate(dc) {
        var timeInfo = Gregorian.info(Time.now(), Time.FORMAT_LONG);    

        dc.clearClip();

        dc.setColor(dayOfTheMonthColor, backgroundColor);
        dc.drawText(locX, locY, Graphics.FONT_MEDIUM, timeInfo.day.toString(), Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(textColor, backgroundColor);
        dc.drawText(
            locX - xOffset,
            locY + yOffset,
            Graphics.Graphics.FONT_TINY,
            timeInfo.day_of_week.substring(0,3),
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        dc.drawText(
            locX + xOffset,
            locY + yOffset,
            Graphics.Graphics.FONT_TINY,
            timeInfo.month,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}
