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
        "Testing mode will last 60 minutes unless you toggle it off\n" ..
        "For Loatheb, testing consists in using the Recently Bandaged as the healer debuff"
L["ARCANE_SHOT_TESTING_ENABLED"] = "Arcane shot testing mode enabled for 60 minutes"
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
L["NEUTRAL_MESSAGE_LABEL"] = "[%s] Effect announce message"
L["SUCCESS_MESSAGE_LABEL"] = "[%s] Successful announce message"
L["FAIL_MESSAGE_LABEL"] = "[%s] Fail announce message"

L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"] = "Tranqshot done on %s"
L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TRANQSHOT FAILED ON %s !!!"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Corrupted Mind on %s"
L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"] = "Distract done"
L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"] = "!!! DISTRACT FAILED !!!"
L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"] = "Fear Ward cast on %s"
L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"] = "AoE taunt for 6 seconds!"
L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"] = "!!! AOE TAUNT MISSED !!!"
L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"] = "Misdirection cast on %s"
L["DEFAULT_BLOODLUST_ANNOUNCE_MESSAGE"] = "BLOODLUST group %s"
L["DEFAULT_GROUNDING_ANNOUNCE_MESSAGE"] = "Grounding Totem group %s"
L["DEFAULT_BREZ_ANNOUNCE_MESSAGE"] = "Battle-rez cast on %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "USE TRANQSHOT NOW !"

L["BROADCAST_MESSAGE_HEADER"] = "Rotation setup text broadcast"
L["USE_MULTILINE_ROTATION_REPORT"] = "Use multiline for main rotation when reporting"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Check this option if you want more comprehensible order display"

    --- Modes
L["SETTING_MODES"] = "Modes"
L["FILTER_SHOW_TRANQSHOT"] = "Tranq"
L["FILTER_SHOW_LOATHEB"] = "Loatheb"
L["FILTER_SHOW_DISTRACT"] = "Distract"
L["FILTER_SHOW_FEARWARD"] = "FearWard"
L["FILTER_SHOW_AOETAUNT"] = "AoE Taunt"
L["FILTER_SHOW_MISDI"] = "Misdi"
L["FILTER_SHOW_BLOODLUST"] = "BL"
L["FILTER_SHOW_GROUNDING"] = "Ground"
L["FILTER_SHOW_BREZ"] = "B-Rez"
L["NO_MODE_AVAILABLE"] = "<Choose modes in settings>"
L["MODE_INVISIBLE"] = "This is the currently selected mode and it will stay that way even though the button is not visible.\nYou may want to click a visible button mode in order to select another mode."
L["TRANQSHOT_MODE_FULL_NAME"] = "Tranquilizing Shot"
L["LOATHEB_MODE_FULL_NAME"] = "Loatheb"
L["DISTRACT_MODE_FULL_NAME"] = "Distract"
L["FEARWARD_MODE_FULL_NAME"] = "Fear Ward"
L["AOETAUNT_MODE_FULL_NAME"] = "Area of Effect Taunt"
L["MISDI_MODE_FULL_NAME"] = "Misdirection"
L["BLOODLUST_MODE_FULL_NAME"] = "Bloodlust/Heroism"
L["GROUNDING_MODE_FULL_NAME"] = "Grounding Totem"
L["BREZ_MODE_FULL_NAME"] = "Battle Rez"
L["TRANQSHOT_MODE_DETAILED_DESC"] = "This mode tracks raid bosses when they enter a Frenzy status and tell hunters to cast the Tranquilizing Shot ability."
L["LOATHEB_MODE_DETAILED_DESC"] = "This mode tracks Loatheb's ability that prevents healers from casting healing spells for 60 seconds."
L["DISTRACT_MODE_DETAILED_DESC"] = "This mode tracks whenever a rogue has cast the Distract ability."
L["FEARWARD_MODE_DETAILED_DESC"] = "This mode tracks whenever a priest has cast the Fear Ward spell."
L["AOETAUNT_MODE_DETAILED_DESC"] = "This mode tracks whenever a warrior has cast the Challenging Shout ability or when a druid has cast the Challenging Roar ability."
L["MISDI_MODE_DETAILED_DESC"] = "This mode tracks whenever a hunter has cast the Misdirection ability."
L["BLOODLUST_MODE_DETAILED_DESC"] = "This mode tracks whenever a shaman has cast the Bloodlust/Heroism ability."
L["GROUNDING_MODE_DETAILED_DESC"] = "This mode tracks whenever a shaman has cast the Grounding Totem ability."
L["BREZ_MODE_DETAILED_DESC"] = "This mode tracks whenever a druid resurrects someone with the Rebirth spell."
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
L["PREPEND_INDEX"] = "Display row number"
L["PREPEND_INDEX_DESC"] = "Display the row number in the rotation before each player name"
L["INDEX_PREFIX_COLOR"] = "Row number color"
L["INDEX_PREFIX_COLOR_DESC"] = "Color of the number if 'Display row number' is enabled"
L["APPEND_GROUP"] = "Append group number"
L["APPEND_GROUP_DESC"] = "Append the group number next to each player name"
L["GROUP_SUFFIX_LABEL"] = "Group suffix"
L["GROUP_SUFFIX_LABEL_DESC"] = "Label used when appending group if 'Append group number' is enabled.\n%s indicates the number"
L["GROUP_SUFFIX_COLOR"] = "Group suffix color"
L["GROUP_SUFFIX_COLOR_DESC"] = "Color of the appended text if 'Append group number' is enabled"
L["DEFAULT_GROUP_SUFFIX_MESSAGE"] = "group %s"
L["APPEND_TARGET"] = "Append target name"
L["APPEND_TARGET_DESC"] = "When a player casts a spell or a buff on a single player target, append the name of the target next to the name of the caster; this option has no effect for AoE spells nor for non-player targets, e.g. mobs"
L["APPEND_TARGET_BUFFONLY"] = "Show the target name only while buffed"
L["APPEND_TARGET_BUFFONLY_DESC"] = "The target name is displayed as long as the buff is active on the target, then hide it when the buff fades; this option has no effect for non-buff modes"
L["APPEND_TARGET_NOGROUP"] = "Hide the group number when there is a target name"
L["APPEND_TARGET_NOGROUP_DESC"] = "When the target name is displayed, hide temporarily the group number in order to save space and reduce clutter"
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

    --- Icons
L["DISPLAY_BLIND_ICON"] = "Show an icon for players without SilentRotate"
L["DISPLAY_BLIND_ICON_DESC"] = "Adds a blind icon next to the player names who have not installed the addon. S/he will not be aware of the rotation and won't be synced if s/he's far from every other SilentRotate user."
L["DISPLAY_BLIND_ICON_TOOLTIP"] = "Show the blind icon tooltip"
L["DISPLAY_BLIND_ICON_TOOLTIP_DESC"] = "You can disable this options to disable the tooltip while still having the icon"

    --- Tooltips
L["TOOLTIP_PLAYER_WITHOUT_ADDON"] = "This player does not use SilentRotate"
L["TOOLTIP_MAY_RUN_OUDATED_VERSION"] = "Or runs an outdated version, older than 0.7.0"
L["TOOLTIP_DISABLE_SETTINGS"] = "(You can disable the icon and/or the tooltip in the settings)"

    --- Notifications
L["UPDATE_AVAILABLE"] = "A new version is available, please update to get the latest features."
L["BREAKING_UPDATE_AVAILABLE"] = "A new, CRITICAL update is available, you MUST update AS SOON AS possible! SilentRotate may not work correctly between you and up-to-date players."

    --- Profiles
L["SETTING_PROFILES"] = "Profiles"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "[%s] Setup"
L["BROADCAST_ROTATION_PREFIX"] = "Rotation"
L["BROADCAST_BACKUP_PREFIX"] = "Backup"
