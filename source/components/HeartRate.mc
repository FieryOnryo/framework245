 using Toybox.Time.Gregorian;
 
/**
 * Component for displaying the heart rate inside a heart icon.
 *
 * Also displays watchface state for deep sleep (Zzz) and power budget exceeded (XX).
 */
class HeartRate extends Component {
 
    private var heartRate = -1;
    private var iconWidth = 0;
    private var fontHeight = 0;
    private var yOffset = 0;
    private var isDeepSleep = false;
    private var deepSleepString = null;
    private var heartRateRefreshFrequency = 5;
    private var font = null;
    private var iconColor = Graphics.COLOR_RED;
    private var backgroundColor = Graphics.COLOR_WHITE;
    private var textColor = Graphics.COLOR_BLACK;
    private var heartRateNoDataString = null;

    function initialize(params) {
        Component.initialize(params);
        font = WatchUi.loadResource(Rez.Fonts.HEART);
    }

    function onLayout(dc) {
        Component.onLayout(dc);
        calculateIconDimens(dc);
        heartRateNoDataString = WatchUi.loadResource(Rez.Strings.HeartNoData);
    }

    function getDoesSupportPartialUpdate() {
        return true;
    }

    function updateAppState(appState) {
        isDeepSleep = appState.getIsDeepSleep();
        var deepSleepStringId = appState.getIsPowerBudgetExceeded() ? 
            Rez.Strings.HeartPowerBudgetExceeded : Rez.Strings.HeartSleep;
        deepSleepString = WatchUi.loadResource(deepSleepStringId);
    }

    function updateSettings(settings) {
        iconColor = settings.highlightColor;
        textColor = settings.foregroundColor;
        backgroundColor = settings.backgroundColor;
        heartRateRefreshFrequency = settings.heartRateRefreshFrequency;    
    }

    function onUpdate(dc) {
        updateHeartRate();
        dc.clearClip();        
        draw(dc);
    }

    /**
     * While this component supports partial updating, updating only occurs when the refresh
     * interval has elapsed and the value has changed for what is currently displayed.
     */
    function onPartialUpdate(dc) {
        var second = Gregorian.info(Time.now(), Time.FORMAT_LONG).sec;
        if (second % heartRateRefreshFrequency != 0) {
            return;
        }
        
        if (!updateHeartRate()) {
            return;
        }

        dc.setClip(locX - (iconWidth / 2) , locY + yOffset, iconWidth, fontHeight);        
        draw(dc);
    }

    function updateHeartRate() {
        var newHeartRate = Activity.getActivityInfo().currentHeartRate;
        if (newHeartRate == null) {
            newHeartRate = 0;
        }
        if (heartRate == newHeartRate) {
            return false;
        }
        heartRate = newHeartRate;
        return true;
    }

    function draw(dc) {
        dc.setColor(iconColor, backgroundColor);
        dc.drawText(locX, locY, font, Icons.HEART, Graphics.TEXT_JUSTIFY_CENTER);
          
        var heartRateString = 
            isDeepSleep ? deepSleepString : 
        	heartRate == 0 ? heartRateNoDataString : heartRate.toString();
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY + yOffset, Graphics.FONT_TINY, heartRateString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function calculateIconDimens(dc) {
        var iconDimensions = dc.getTextDimensions(Icons.HEART, font);
        iconWidth = iconDimensions[0];
        fontHeight = dc.getFontHeight(Graphics.FONT_TINY);
        yOffset = (iconDimensions[1] - fontHeight) / 1.8;
    }
 }
 