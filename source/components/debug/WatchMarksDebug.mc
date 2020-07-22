/**
 * A component for drawing the watchface marks using text.
 * Used for creating a bitmap image for the WatchMarks component.
 */
class WatchMarksDebug extends WatchMarks {

    private var backgroundColor = Graphics.COLOR_WHITE;
    private var foregroundColor = Graphics.COLOR_BLACK;
    private var mainGrayColor = Graphics.COLOR_DK_GRAY;
    private var secondaryGrayColor = Graphics.COLOR_LT_GRAY;

    function initialize(params) {
        WatchMarks.initialize(params);
    }

    function getDoesSupportPartialUpdate() {
        return false;
    }

    function onUpdate(dc) {
        drawAllWatchMarks(dc);
    }

    function updateSettings(settings) {
        backgroundColor = settings.backgroundColor;
        foregroundColor = settings.foregroundColor;
        mainGrayColor = settings.mainGrayColor;
        secondaryGrayColor = settings.secondaryGrayColor;
    }

    private function drawAllWatchMarks(dc) {
        dc.clearClip();
        dc.setColor(backgroundColor, backgroundColor);
        dc.clear();
        for(var second = 0; second < 60; second++) {
            drawSecond(dc, second, getMarkColor(second));
        }
    }

    private function drawSecond(dc, second, color) {
        var x = markPositions[second * 2];
        var y = markPositions[second * 2 + 1];
        var clipBoxOffset = clipBoxSize / 2;
        dc.setColor(color, backgroundColor);
        dc.setClip(x, y, clipBoxSize, clipBoxSize);
        dc.drawText(
            x + clipBoxOffset,
            y + clipBoxOffset,
            FONT,
            MARK_CHARACTER,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function getMarkColor(second) {
        return second % 5 != 0 ? secondaryGrayColor :
                second % 15 == 0 ? foregroundColor : mainGrayColor;
    }
}
