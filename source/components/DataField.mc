using Toybox.Time.Gregorian;

/**
 * Component for displaying various data fields.
 *
 * Supports:
 *      Daily steps
 *      Total daily Calories
 *      Active daily Calories
 *      Resting daily Calories
 *      Daily distance
 *      Active daily minutes
 *      Active weekly minutes
 *      Daily floors climbed (945 only)
 *      Daily floors descended (945 only)
 */
class DataField extends Component {

    enum {
        STEPS = 0,
        TOTAL_CALORIES = 1,
        ACTIVE_CALORIES = 2,
        RESTING_CALORIES = 3,
        DISTANCE = 4,
        ACTIVE_MINUTES_DAY = 5,
        ACTIVE_MINUTES_WEEK = 6,
        FLOORS_CLIMBED = 7,
        FLOORS_DESCENDED = 8,
    }

    private const UNIT_KILOMETERS = "km";
    private const UNIT_MILES = "mi";
    private const NULL_CHARACTER = "-";
    private const ELLIPSIS = "...";

    private var dataIndex = 0;
    private var maxCharacters = 5;
    private var backgroundColor = Graphics.COLOR_WHITE;
    private var textColor = Graphics.COLOR_BLACK;
    private var iconColor = Graphics.COLOR_DK_GRAY;
    private var xOffset = 0;
    private var font = null;
    private var type = STEPS;
    private var isMetric = true;
    
    private var iconCharacters = {
        STEPS => Icons.STEPS,
        TOTAL_CALORIES => Icons.CALORIES,
        ACTIVE_CALORIES => Icons.CALORIES,
        RESTING_CALORIES => Icons.CALORIES,
        DISTANCE => Icons.DISTANCE,
        ACTIVE_MINUTES_DAY => Icons.TIME,
        ACTIVE_MINUTES_WEEK => Icons.TIME,
        FLOORS_CLIMBED => Icons.FLOORS,
        FLOORS_DESCENDED => Icons.FLOORS
    };
    
    function initialize(params) {
        Component.initialize(params);
        dataIndex = getParam(params, :index, 0);
        maxCharacters = getParam(params, :maxLength, 0);
        font = WatchUi.loadResource(Rez.Fonts.ICONS);
    }

    function onLayout(dc) {
        Component.onLayout(dc);  
        xOffset = screenDiameter * 0.07;
    }

    function updateSettings(settings) {
        type = settings.dataType[dataIndex];
        iconColor = settings.mainGrayColor;
        textColor = settings.foregroundColor;
        backgroundColor = settings.backgroundColor;
        isMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
    }

    function onUpdate(dc) {
        dc.clearClip();
        dc.setColor(iconColor, backgroundColor);
        dc.drawText(locX, locY, font, iconCharacters[type], Graphics.TEXT_JUSTIFY_CENTER);

        var value = getValue();
        value = value == null ? NULL_CHARACTER : value.toString();
        if (value.length() > maxCharacters) {
            value = value.substring(0, maxCharacters - 2) + ELLIPSIS;
        }
        dc.setColor(textColor, backgroundColor);
        dc.drawText(locX + xOffset, locY, Graphics.FONT_TINY, value, Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function getValue() {
        var info = ActivityMonitor.getInfo();
        switch (type) {
            case STEPS:
                return info has :steps ? info.steps :  null;
            case TOTAL_CALORIES:
                return info has :calories ? info.calories :  null;
            case ACTIVE_CALORIES:                
            case RESTING_CALORIES:
                return info has :calories ? calculateCalories(info.calories) : null;
            case DISTANCE:
                return info has :distance ? formatDistance(info.distance) : null;
            case ACTIVE_MINUTES_DAY:
                return info has :activeMinutesDay ? info.activeMinutesDay.total : null;
            case ACTIVE_MINUTES_WEEK:
                return info has :activeMinutesWeek ? info.activeMinutesWeek.total : null;
            case FLOORS_CLIMBED:
                return info has :floorsClimbed ? info.floorsClimbed :  null;
            case FLOORS_DESCENDED:
                return info has :floorsDescended ? info.floorsDescended :  null;
        }
        return null;
    }

    // Props to markdotai and topcaser on Garmin Forum
    // https://forums.garmin.com/developer/connect-iq/f/discussion/208338/active-calories
    private function calculateCalories(calories) {
        if (calories == null) {
            return 0;
        }
            
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);     
        var profile = UserProfile.getProfile();
        var age = today.year - profile.birthYear;
        var weight = profile.weight / 1000.0;

        var restCalories = 0;
        if (profile.gender == UserProfile.GENDER_MALE) {
            restCalories = 5.2 - 6.116 * age + 7.628 * profile.height + 12.2 * weight;
        } else {
            restCalories = -197.6 - 6.116 * age + 7.628 * profile.height + 12.2 * weight;
        }
        restCalories = Math.round((today.hour * 60 + today.min) * restCalories / 1440 ).toNumber();
        
        var activeCalories = calories - restCalories;
        activeCalories = activeCalories < 0 ? 0 : activeCalories;
        
        return type == ACTIVE_CALORIES ? activeCalories : restCalories;
    }

    private function formatDistance(distance) {
        if (distance == null) {
            return null;
        }
        var convertedDistance = isMetric ?  distance / 100000f : distance / 160934f;
        var unitString = isMetric ? UNIT_KILOMETERS : UNIT_MILES;
        return convertedDistance.format("%.1f") + unitString;
    }
}
