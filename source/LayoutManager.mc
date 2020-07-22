using Toybox.Lang;

/**
 * Class for loading watchface layouts from the associated xml.
 */
class LayoutManager {

    static enum {
        WATCH_MARKS_DEBUG = -1,
        BATTERY_ICON = 0,
        BATTERY_ARC = 1
    }

    private static const layouts = {
        WATCH_MARKS_DEBUG => :WatchMarksDebugLayout,
        BATTERY_ICON => :BatteryIconLayout,
        BATTERY_ARC => :BatteryArcLayout
    };

    /**
     * Returns an array consisting of the components used in the associated layout.
     */
    static function getComponents(dc, layoutIndex) {
        var layoutMethod = new Lang.Method(Rez.Layouts, layouts[layoutIndex]);
        return layoutMethod.invoke(dc);
    }
}
