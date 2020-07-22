using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time.Gregorian;

/**
 * Component for drawing the watchmarks and displaying the seconds marker.
 *
 * When the watch enters deep sleep, this will clear the seconds marker.
 *
 * This originally drew the watchmarks as a font but the overheads were too high
 * for smoothly loading the watchface. Using a bitmap instead improves this and
 * also reduces the overheads for partial updates.
 */
class WatchMarks extends Component {

    // Protected for debug class
    protected const MARK_CHARACTER = "•";
    protected const FONT = Graphics.FONT_SYSTEM_LARGE;
    protected var markPositions = null;
    protected var clipBoxSize = 0;
    
    private var backgroundColor = Graphics.COLOR_WHITE;
    private var highlightColor = Graphics.COLOR_RED;
    private var backgroundBitmap = null;
    private var highlightBitmap = null;
    private var isDeepSleep = false;
    private var isSecondsMarkEnabled = true;

    function initialize(params) {
        Component.initialize(params);        
    }

    function getDoesSupportPartialUpdate() {
        return true;
    }

    function onLayout(dc) {
        Component.onLayout(dc);
        calculateClipBoxSize(dc);
        initializeMarkPositions();    
    }

    function updateAppState(appState) {
        isDeepSleep = appState.getIsDeepSleep();
    }

    function updateSettings(settings) {
        isSecondsMarkEnabled = settings.isSecondsMarkEnabled;
        backgroundColor = settings.backgroundColor;
        highlightColor = settings.highlightColor;

        createHighlightBitmap();
        loadBackgroundBitmap(settings);
    }

    function loadBackgroundBitmap(settings) {        
        var backgroundRezId = settings.isDarkModeEnabled ? Rez.Drawables.DarkBackground : Rez.Drawables.LightBackground;

        // Set this to null so the memory is deallocated before loading the new bitmap.
        backgroundBitmap = null;
        backgroundBitmap = new WatchUi.Bitmap({
            :rezId=>backgroundRezId,
            :locX=>locX,
            :locY=>locY
        });
    }

    function createHighlightBitmap() {
        highlightBitmap = new Graphics.BufferedBitmap({
            :width=>clipBoxSize,
            :height=>clipBoxSize
        });
        var dc = highlightBitmap.getDc();
        dc.setColor(highlightColor, backgroundColor);
        dc.drawText(clipBoxSize / 2, clipBoxSize / 2, FONT, MARK_CHARACTER, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onUpdate(dc) {
        dc.clearClip();
        draw(dc, Gregorian.info(Time.now(), Time.FORMAT_LONG).sec);
    }

    function onPartialUpdate(dc) {
        var second = Gregorian.info(Time.now(), Time.FORMAT_LONG).sec;
        var lastSecond = ((second + 59) % 60) * 2;
        var x = markPositions[lastSecond];
        var y = markPositions[lastSecond + 1];
        dc.setClip(x, y, clipBoxSize, clipBoxSize);
        draw(dc, second);
    }

    function draw(dc, second) {
        backgroundBitmap.draw(dc);
        if (!isDeepSleep && isSecondsMarkEnabled) {
            drawSecond(dc, second);
        }
    }

    private function drawSecond(dc, second) {       
        var x = markPositions[second * 2];
        var y = markPositions[second * 2 + 1];
        dc.setClip(x, y, clipBoxSize, clipBoxSize);
        dc.drawBitmap(x, y, highlightBitmap);
    }

    private function initializeMarkPositions() {
    	markPositions = new [60 * 2];
        var drawRadius = screenDiameter * 0.47;
        for (var second = 0; second < 60; second++) {
            var point = calculateWatchMarkPosition(second, drawRadius);
            markPositions[second * 2] = point[0];
            markPositions[second * 2 + 1] = point[1];
        }
    }

    private function calculateWatchMarkPosition(second, drawRadius) {
        var angle = 2 * Math.PI * (30 - second) / 60f;
        var clipBoxOffset = clipBoxSize / 2;
        var screenRadius = screenDiameter / 2;
        var x = drawRadius * Math.sin(angle) + screenRadius - clipBoxOffset;
        var y = drawRadius * Math.cos(angle) + screenRadius - clipBoxOffset;
        return [x, y];
    }

    private function calculateClipBoxSize(dc) {
        // When we check the width using dc.getTextWidthInPixels(MARK_CHARACTER, Graphics.FONT_SYSTEM_LARGE),
    	// we get 11px on a ForeRunner 245, but we can pull that in a bit to 9px without making any visible impact.
    	// This gains roughly 0.5 ms during a partial update, but might limit portability.
    	clipBoxSize = (dc.getTextWidthInPixels(MARK_CHARACTER, FONT) * 0.9).toNumber();
    }
}
