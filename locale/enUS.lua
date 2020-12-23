local L = LibStub("AceLocale-3.0"):NewLocale("SilentRotate", "enUS", true, false)
if not L then return end
L["LOADED_MESSAGE"] = "SilentRotate loaded, type /silentrotate for options"
L["TRANQ_WINDOW_HIDDEN"] = "SilentRotate window hidden. Use /silentrotate toggle to get it back"

    -- Settings
L["SETTING_GENERAL"] = "General"
L["SETTING_GENERAL_REPORT"] = "Please report any issue at"
L["SETTING_GENERAL_DESC"] = "Work in Progress: SilentRotate is an extension of TranqRotate. While TranqRotate is dedicated to hunter tranqshots, SilentRotate adds \"modes\" for other classes or spells."

L["LOCK_WINDOW"] = "Lock window"
L["LOCK_WINDOW_DESC"] = "Lock window"
L["HIDE_WINDOW_NOT_IN_RAID"] = "Hide the window when not in a raid"
L["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Hide the window when not in a raid"
L["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Do not show window when joining a raid"
L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Check this if you don't want the window to show up each time you join a raid"
L["SHOW_WHEN_TARGETING_BOSS"] = "Show window when you target a tranq-able boss"
L["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Show window when you target a tranq-able boss"
L["WINDOW_LOCKED"] = "SilentRotate: Window locked"
L["WINDOW_UNLOCKED"] = "SilentRotate: Window unlocked"

L["TEST_MODE_HEADER"] = "Test mode"
L["ENABLE_ARCANE_SHOT_TESTING"] = "Toggle testing mode"
L["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "While testing mode is enabled, arcane shot will be registered as a tranqshot\n" ..
        "Testing mode will last 10 minutes unless you toggle it off\n" ..
        "For Loatheb, testing consists in using the Recently Bandaged as the healer debuff"
L["ARCANE_SHOT_TESTING_ENABLED"] = "Arcane shot testing mode enabled for 10 minutes"
L["ARCANE_SHOT_TESTING_DISABLED"] = "Arcane shot testing mode disabled"

    --- Announces
L["SETTING_ANNOUNCES"] = "Announces"
L["ENABLE_ANNOUNCES"] = "Enable announces"
L["ENABLE_ANNOUNCES_DESC"] = "Enable / disable the announcement."

    ---- Channels
L["ANNOUNCES_CHANNEL_HEADER"] = "Announce channel"
L["MESSAGE_CHANNEL_TYPE"] = "Send messages to"
L["MESSAGE_CHANNEL_TYPE_DESC"] = "Channel you want to send messages"
L["MESSAGE_CHANNEL_NAME"] = "Channel name"
L["MESSAGE_CHANNEL_NAME_DESC"] = "Set the name of the target channel"

    ----- Channels types
L["CHANNEL_CHANNEL"] = "Channel"
L["CHANNEL_RAID_WARNING"] = "Raid Warning"
L["CHANNEL_SAY"] = "Say"
L["CHANNEL_YELL"] = "Yell"
L["CHANNEL_PARTY"] = "Party"
L["CHANNEL_RAID"] = "Raid"
L["CHANNEL_GUILD"] = "Guild"

    ---- Messages
L["ANNOUNCES_MESSAGE_HEADER"] = "Announce messages"
L["SUCCESS_MESSAGE_LABEL"] = "Successful announce message"
L["FAIL_MESSAGE_LABEL"] = "Fail announce message"
L["FAIL_WHISPER_LABEL"] = "Fail whisper message"
L["LOATHEB_MESSAGE_LABEL"] = "Loatheb debuff applied"

L["DEFAULT_SUCCESS_ANNOUNCE_MESSAGE"] = "Tranqshot done on %s"
L["DEFAULT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TRANQSHOT FAILED ON %s !!!"
L["DEFAULT_FAIL_WHISPER_MESSAGE"] = "TRANQSHOT FAILED ! TRANQ NOW !"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Corrupted Mind on %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "USE TRANQSHOT NOW !"

L["TRANQ_SPELL_TEXT"] = "Tranqshot"
L["MC_SPELL_TEXT"] = "Mind Control"

L["BROADCAST_MESSAGE_HEADER"] = "Rotation setup text broadcast"
L["USE_MULTILINE_ROTATION_REPORT"] = "Use multiline for main rotation when reporting"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Check this option if you want more comprehensible order display"

    --- Modes
L["SETTING_MODES"] = "Modes"
L["FILTER_SHOW_HUNTERS"] = "Tranq"
L["FILTER_SHOW_PRIESTS"] = "Raz"
L["FILTER_SHOW_HEALERS"] = "Loatheb"
L["FILTER_SHOW_ROGUES"] = "Distract"
L["NO_MODE_AVAILABLE"] = "<Choose modes in settings>"
L["TRANQ_MODE_FULL_NAME"] = "Tranquilizing Shot"
L["LOATHEB_MODE_FULL_NAME"] = "Loatheb"
L["DISTRACT_MODE_FULL_NAME"] = "Distract"
L["RAZ_MODE_FULL_NAME"] = "Razuvious"
L["MODE_BUTTON_DESC"] = "Show the button for activating the mode '%s'"
L["MODE_LABEL"] = "Button Text"
L["MODE_LABEL_DESC"] = "Text that appears in the button for activating the mode '%s'"

    --- Names
L["SETTING_NAMES"] = "Names"
L["NAME_TAG_HEADER"] = "Name Tags"
L["USE_CLASS_COLOR"] = "Class color"
L["USE_CLASS_COLOR_DESC"] = "Colorize names based on class"
L["USE_NAME_OUTLINE"] = "Name outline"
L["USE_NAME_OUTLINE_DESC"] = "Display a thin black outline around the names"
L["APPEND_GROUP"] = "Append group number"
L["APPEND_GROUP_DESC"] = "Append the group number next to each player name"
L["GROUP_SUFFIX_LABEL"] = "Group suffix"
L["GROUP_SUFFIX_LABEL_DESC"] = "Label used when appending group if 'Append group number' is enabled.\n%s indicates the number"
L["GROUP_SUFFIX_COLOR"] = "Group suffix color"
L["GROUP_SUFFIX_COLOR_DESC"] = "Color of the appended text if 'Append group number' is enabled"
L["DEFAULT_GROUP_SUFFIX_MESSAGE"] = "group %s"
L["BACKGROUND_HEADER"] = "Background"
L["NEUTRAL_BG"] = "Neutral"
L["NEUTRAL_BG_DESC"] = "Standard background color for units"
L["ACTIVE_BG"] = "Active"
L["ACTIVE_BG_DESC"] = "Background color for the unit who is the current focus in the rotation"
L["DEAD_BG"] = "Dead"
L["DEAD_BG_DESC"] = "Background color for dead units"
L["OFFLINE_BG"] = "Offline"
L["OFFLINE_BG_DESC"] = "Background color for offline units"

    --- Sounds
L["SETTING_SOUNDS"] = "Sounds"
L["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Play a sound when you are the next to shoot"
L["ENABLE_TRANQ_NOW_SOUND"] = "Play a sound when you have to shoot your spell"
L["TRANQ_NOW_SOUND_CHOICE"] = "Select the sound you want to use for the 'cast now' alert"
L["DBM_SOUND_WARNING"] = "DBM is playing the 'flag taken' sound on each frenzy, it may prevent you from earing gentle sounds from SilentRotate. I would either suggest to pick a strong sound or disable DBM frenzy sound."

    --- Profiles
L["SETTING_PROFILES"] = "Profiles"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "Hunter tranqshot setup"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "Priest MC setup"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "Loatheb Healer setup"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "Rogue distract setup"
L["BROADCAST_ROTATION_PREFIX"] = "Rotation"
L["BROADCAST_BACKUP_PREFIX"] = "Backup"
