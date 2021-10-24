local L = LibStub("AceLocale-3.0"):NewLocale("SilentRotate", "zhTW", false, false)
if not L then return end
L["LOADED_MESSAGE"] = "SilentRotate 已加載, 輸入 /silentrotate 進入設定"
L["TRANQ_WINDOW_HIDDEN"] = "SilentRotate 窗口隱藏. 輸入 /silentrotate toggle 顯示窗口"

    -- Buttons
L["BUTTON_SETTINGS"] = "Settings"
L["BUTTON_RESET_ROTATION"] = "Reset Rotation"
L["BUTTON_PRINT_ROTATION"] = "Print Rotation"
L["BUTTON_HISTORY"] = "History"
L["BUTTON_RESPAWN_HISTORY"] = "Respawn old messages"
L["BUTTON_CLEAR_HISTORY"] = "Clear"

    -- Settings
L["SETTING_GENERAL"] = "General"
L["SETTING_GENERAL_REPORT"] = "請報告問題: "
L["SETTING_GENERAL_DESC"] = "New : SilentRotate will now play a sound when you need to shoot your tranqshot ! There are also few more display options to make the addon less intrusive."

L["LOCK_WINDOW"] = "鎖定窗口"
L["LOCK_WINDOW_DESC"] = "鎖定窗口"
L["HIDE_WINDOW_NOT_IN_RAID"] = "不在團隊時隱藏窗口"
L["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "不在團隊時隱藏窗口"
L["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "加入團隊時隱藏窗口"
L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "如果您不想每次加入團隊時都顯示窗口，請選中此選項"
L["SHOW_WHEN_TARGETING_BOSS"] = "當妳的目標是壹個可寧神的Boss時，顯示窗口"
L["SHOW_WHEN_TARGETING_BOSS_DESC"] = "當妳的目標是壹個可寧神的Boss時，顯示窗口"
L["WINDOW_LOCKED"] = "SilentRotate: 窗口已隱藏"
L["WINDOW_UNLOCKED"] = "SilentRotate: 窗口已鎖定"

L["TEST_MODE_HEADER"] = "測試模式"
L["ENABLE_ARCANE_SHOT_TESTING"] = "切換測試模式"
L["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "當測試模式啟用時, 秘法射擊將註冊為寧神射擊\n" ..
        "測試模式將持續60分鐘, 除非妳提前關閉它\n" ..
        "For Loatheb, testing consists in using the Recently Bandaged as the healer debuff"
L["ARCANE_SHOT_TESTING_ENABLED"] = "奧術射擊測試模式已啟用, 持續60分鐘"
L["ARCANE_SHOT_TESTING_DISABLED"] = "奧術射擊測試模式已禁用"

    --- Announces
L["SETTING_ANNOUNCES"] = "通告"
L["ENABLE_ANNOUNCES"] = "啟用通告"
L["ENABLE_ANNOUNCES_DESC"] = "啟用 / 禁用通告"

    ---- Channels
L["ANNOUNCES_CHANNEL_HEADER"] = "通告頻道"
L["MESSAGE_CHANNEL_TYPE"] = "發送到"
L["MESSAGE_CHANNEL_TYPE_DESC"] = "你想發送到哪個頻道"
L["MESSAGE_CHANNEL_NAME"] = "頻道名或玩家名"
L["MESSAGE_CHANNEL_NAME_DESC"] = "設置目標頻道的名稱"

    ----- Channels types
L["CHANNEL_CHANNEL"] = "頻道"
L["CHANNEL_RAID_WARNING"] = "團隊警告"
L["CHANNEL_SAY"] = "說"
L["CHANNEL_YELL"] = "大喊"
L["CHANNEL_PARTY"] = "小隊"
L["CHANNEL_RAID"] = "團隊"
L["CHANNEL_GUILD"] = "公會"

    ---- Messages
L["ANNOUNCES_MESSAGE_HEADER"] = "通告資訊"
L["NEUTRAL_MESSAGE_LABEL"] = "[%s] Effect announce message"
L["SUCCESS_MESSAGE_LABEL"] = "[%s] 施放成功通告資訊"
L["FAIL_MESSAGE_LABEL"] = "[%s] 施放失敗通告資訊"

L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"] = "已對 %s 施放了寧神射擊!"
L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"] = "!!! 對 %s 寧神失敗!!!"
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
L["DEFAULT_INNERV_ANNOUNCE_MESSAGE"] = "Innervate cast on %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "立即使用寧神 !!"

L["BROADCAST_MESSAGE_HEADER"] = "循環順序廣播頻道選擇"
L["USE_MULTILINE_ROTATION_REPORT"] = "連續多行發送寧神通告"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "如果您想要更易於理解的順序顯示，請選中此選項"

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
L["FILTER_SHOW_INNERV"] = "Innerv"
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
L["INNERV_MODE_FULL_NAME"] = "Innervate"
L["TRANQSHOT_MODE_DETAILED_DESC"] = "This mode tracks raid bosses when they enter a Frenzy status and tell hunters to cast the Tranquilizing Shot ability."
L["LOATHEB_MODE_DETAILED_DESC"] = "This mode tracks Loatheb's ability that prevents healers from casting healing spells for 60 seconds."
L["DISTRACT_MODE_DETAILED_DESC"] = "This mode tracks whenever a rogue has cast the Distract ability."
L["FEARWARD_MODE_DETAILED_DESC"] = "This mode tracks whenever a priest has cast the Fear Ward spell."
L["AOETAUNT_MODE_DETAILED_DESC"] = "This mode tracks whenever a warrior has cast the Challenging Shout ability or when a druid has cast the Challenging Roar ability."
L["MISDI_MODE_DETAILED_DESC"] = "This mode tracks whenever a hunter has cast the Misdirection ability."
L["BLOODLUST_MODE_DETAILED_DESC"] = "This mode tracks whenever a hunter has cast the Bloodlust/Heroism ability."
L["GROUNDING_MODE_DETAILED_DESC"] = "This mode tracks whenever a shaman has cast the Grounding Totem ability."
L["BREZ_MODE_DETAILED_DESC"] = "This mode tracks whenever a druid resurrects someone with the Rebirth spell."
L["INNERV_MODE_DETAILED_DESC"] = "This mode tracks whenever a druid regenerates mana to someone with the Innervate spell."
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
L["SETTING_SOUNDS"] = "音效"
L["ENABLE_NEXT_TO_TRANQ_SOUND"] = "當下壹個寧神射擊是您時，播放提示音"
L["ENABLE_TRANQ_NOW_SOUND"] = "當您需要立即寧神射擊時，播放提示音"
L["TRANQ_NOW_SOUND_CHOICE"] = "選擇要用於“寧神射擊”提示的聲音"
L["DBM_SOUND_WARNING"] = "DBM在瘋狂時播放的'flag taken'提示音，可能導致您無法聽到SilentRotate的提示音。建議選擇壹個響亮的提示音，或者在DBM中禁用瘋狂的警告。"

    --- History
L["SETTING_HISTORY"] = "History"
L["HISTORY_FADEOUT"] = "Time to Fade"
L["HISTORY_FADEOUT_DESC"] = "Time, in seconds, to keep messages visible in the History window.\n" ..
        "Old messages can be displayed back, using the Respawn button.\n" ..
        "Hitting the Clear button erases all messages, current and past, forever."
L["HISTORY_FONTSIZE"] = "Font Size"

L["HISTORY_DEBUFF_RECEIVED"] = "%s is afflicted by %s."
L["HISTORY_SPELLCAST_NOTARGET"] = "%s casts %s."
L["HISTORY_SPELLCAST_SUCCESS"] = "%s casts %s on %s."
L["HISTORY_SPELLCAST_FAILURE"] = "%s FAILS to cast %s on %s."
L["HISTORY_TRANQSHOT_FRENZY"] = "%s enters %s."
L["HISTORY_GROUNDING_SUMMON"] = "Totem of %s is protecting ||group|| %s."
L["HISTORY_GROUNDING_EXPIRE"] = "Totem of %s expires."
L["HISTORY_GROUNDING_ABSORB"] = "Totem of %s absorbs %s from %s."
L["HISTORY_GROUNDING_ABSORB_NOSPELL"] = "Totem of %s absorbs attack from %s."

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
L["SETTING_PROFILES"] = "設定檔"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "[%s]順序"
L["BROADCAST_ROTATION_PREFIX"] = "循環"
L["BROADCAST_BACKUP_PREFIX"] = "替補"
