/**
 * Data class containing the icons used in the application and their associated ascii character.
 */
class Icons {

    // battery.fnt
    static const BATTERY = loadCharacter(83);

    // heart.fnt
    static const HEART = loadCharacter(109);

    // icons.fnt
    static const BLUETOOTH = loadCharacter(86);
    static const CALORIES = loadCharacter(88);
    static const DISTANCE = loadCharacter(94);
    static const DO_NOT_DISTURB = loadCharacter(127);
    static const FLOORS = loadCharacter(101);
    static const NOTIFICATIONS = loadCharacter(194);
    static const PHONE = loadCharacter(193);
    static const STEPS = loadCharacter(197);
    static const TIME = loadCharacter(208);
    static const WIFI = loadCharacter(207);

    static function loadCharacter(asciiValue) {
        return asciiValue.toChar().toString();
    }
}
