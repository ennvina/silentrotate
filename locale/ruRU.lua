local L = LibStub("AceLocale-3.0"):NewLocale("SilentRotate", "ruRU", false, false)
if not L then return end
L["LOADED_MESSAGE"] = "SilentRotate загружен, введите /silentrotate для настройки"
L["TRANQ_WINDOW_HIDDEN"] = "Окно SilentRotate скрыто. Введите /silentrotate toggle для отображения"

    -- Settings
L["SETTING_GENERAL"] = "Общие"
L["SETTING_GENERAL_REPORT"] = "Пожалуйста о всех ошибках сообщайте на"
L["SETTING_GENERAL_DESC"] = "Новое: Теперь SilentRotate проигрывает звук когда подходит ваша очередь! Добавлено несколько настроек отображения, чтобы сделать аддон менее навязчивым."

L["LOCK_WINDOW"] = "Закрепить окно"
L["LOCK_WINDOW_DESC"] = "Препятствует перемещению окна с помощью мыши"
L["HIDE_WINDOW_NOT_IN_RAID"] = "Показывать окно только в рейде"
L["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Окно будет отображаться только в рейдовой группе"
L["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Не показывать окно во время присоединения к рейду"
L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Выберите если вы не хотите видеть окно каждый раз когда присоединяетесь к рейду"
L["SHOW_WHEN_TARGETING_BOSS"] = "Показывать окно только если ваша цель может быть усмирена"
L["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Показывать окно только если ваша цель может быть усмирена"
L["WINDOW_LOCKED"] = "SilentRotate: Окно закреплено"
L["WINDOW_UNLOCKED"] = "SilentRotate: Окно откреплено"

L["TEST_MODE_HEADER"] = "Тестовый режим"
L["ENABLE_ARCANE_SHOT_TESTING"] = "Тестовый режим"
L["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "В режиме тестирования, Чародейский выстрел будет использоваться вместо Усмиряющего выстрела\n" ..
        "Режим тестирования работает 60 минут или до отключения\n" ..
        "For Loatheb, testing consists in using the Recently Bandaged as the healer debuff"
L["ARCANE_SHOT_TESTING_ENABLED"] = "Тестовый режим включен на 60 минут"
L["ARCANE_SHOT_TESTING_DISABLED"] = "Тестовый режим выключен"

    --- Announces
L["SETTING_ANNOUNCES"] = "Оповещения"
L["ENABLE_ANNOUNCES"] = "Включить оповещения"
L["ENABLE_ANNOUNCES_DESC"] = "Включить / отключить оповещения"

    ---- Channels
L["ANNOUNCES_CHANNEL_HEADER"] = "Канал оповещений"
L["MESSAGE_CHANNEL_TYPE"] = "Канал чата"
L["MESSAGE_CHANNEL_TYPE_DESC"] = "Канал для отправки оповещений"
L["MESSAGE_CHANNEL_NAME"] = "Имя канала"
L["MESSAGE_CHANNEL_NAME_DESC"] = "Установить имя канала для оповещений"

    ----- Channels types
L["CHANNEL_CHANNEL"] = "Канал"
L["CHANNEL_RAID_WARNING"] = "Объявления рейду"
L["CHANNEL_SAY"] = "Сказать"
L["CHANNEL_YELL"] = "Крик"
L["CHANNEL_PARTY"] = "Группа"
L["CHANNEL_RAID"] = "Рейд"
L["CHANNEL_GUILD"] = "Гильдия"

    ---- Messages
L["ANNOUNCES_MESSAGE_HEADER"] = "Сообщения оповещений"
L["TRANQSHOT_SUCCESS_MESSAGE_LABEL"] = "При успехе сообщить"
L["TRANQSHOT_FAIL_MESSAGE_LABEL"] = "При промахе сообщить"
--L["FAIL_WHISPER_LABEL"] = "При промахе шепнуть запасным"
L["LOATHEB_MESSAGE_LABEL"] = "Loatheb debuff applied"
L["DISTRACT_SUCCESS_MESSAGE_LABEL"] = "Distract successful announce message"
L["DISTRACT_FAIL_MESSAGE_LABEL"] = "Distract fail announce message"
L["FEARWARD_MESSAGE_LABEL"] = "Fear ward announce message"
L["AOETAUNT_SUCCESS_MESSAGE_LABEL"] = "AoE taunt successful announce message"
L["AOETAUNT_FAIL_MESSAGE_LABEL"] = "AoE taunt fail announce message"
L["MISDI_MESSAGE_LABEL"] = "Misdirection announce message"
L["BLOODLUST_MESSAGE_LABEL"] = "Bloodlust/Heroism announce message"

L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"] = "Усмиряющий выстрел в %s"
L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"] = "!!! Усмиряющий выстрел промах в %s !!!"
L["DEFAULT_TRANQSHOT_FAIL_WHISPER_MESSAGE"] = "!!! Усмиряющий выстрел промах !!! ! СТРЕЛЯЙ СЕЙЧАС !"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Испорченный разум в %s"
L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"] = "Distract done"
L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"] = "!!! DISTRACT FAILED !!!"
L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"] = "Fear Ward cast on %s"
L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"] = "AoE taunt for 6 seconds!"
L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"] = "!!! AOE TAUNT MISSED !!!"
L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"] = "Misdirection cast on %s"
L["DEFAULT_BLOODLUST_ANNOUNCE_MESSAGE"] = "BLOODLUST group %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "СТРЕЛЯЙ СЕЙЧАС !"

L["TRANQ_SPELL_TEXT"] = "Усмиряющий выстрел"
L["MC_SPELL_TEXT"] = "Контроль над разумом"

L["BROADCAST_MESSAGE_HEADER"] = "Объявление очередности"
L["USE_MULTILINE_ROTATION_REPORT"] = "Использовать многострочный вывод при объявлении очередности"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Выберите для более понятного порядка отображения очередности"

    --- Modes
L["SETTING_MODES"] = "Modes"
L["FILTER_SHOW_HUNTERS"] = "Tranq"
L["FILTER_SHOW_PRIESTS"] = "Raz"
L["FILTER_SHOW_HEALERS"] = "Loatheb"
L["FILTER_SHOW_ROGUES"] = "Distract"
L["FILTER_SHOW_DWARVES"] = "FearWard"
L["FILTER_SHOW_AOETAUNTERS"] = "AoE Taunt"
L["FILTER_SHOW_MISDIRECTORS"] = "Misdi"
L["FILTER_SHOW_SHAMANS"] = "BL"
L["NO_MODE_AVAILABLE"] = "<Choose modes in settings>"
L["MODE_INVISIBLE"] = "This is the currently selected mode and it will stay that way even though the button is not visible.\nYou may want to click a visible button mode in order to select another mode."
L["TRANQ_MODE_FULL_NAME"] = "Tranquilizing Shot"
L["LOATHEB_MODE_FULL_NAME"] = "Loatheb"
L["DISTRACT_MODE_FULL_NAME"] = "Distract"
L["RAZ_MODE_FULL_NAME"] = "Razuvious"
L["FEARWARD_MODE_FULL_NAME"] = "Fear Ward"
L["AOETAUNT_MODE_FULL_NAME"] = "Area of Effect Taunt"
L["MISDI_MODE_FULL_NAME"] = "Misdirection"
L["BLOODLUST_MODE_FULL_NAME"] = "Bloodlust/Heroism"
L["TRANQ_MODE_DETAILED_DESC"] = "This mode tracks raid bosses when they enter a Frenzy status and tell hunters to cast the Tranquilizing Shot ability."
L["LOATHEB_MODE_DETAILED_DESC"] = "This mode tracks Loatheb's ability that prevents healers from casting healing spells for 60 seconds."
L["DISTRACT_MODE_DETAILED_DESC"] = "This mode tracks whenever a rogue has cast the Distract ability."
L["RAZ_MODE_DETAILED_DESC"] = "This mode tracks priests who are casting Mind Control on Razuvious' adds, a.k.a. Death Knight Understudy."
L["FEARWARD_MODE_DETAILED_DESC"] = "This mode tracks whenever a priest has cast the Fear Ward spell."
L["AOETAUNT_MODE_DETAILED_DESC"] = "This mode tracks whenever a warrior has cast the Challenging Shout ability or when a druid has cast the Challenging Roar ability."
L["MISDI_MODE_DETAILED_DESC"] = "This mode tracks whenever a hunter has cast the Misdirection ability."
L["BLOODLUST_MODE_DETAILED_DESC"] = "This mode tracks whenever a hunter has cast the Bloodlust/Heroism ability."
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
L["DEFAULT_GROUP_SUFFIX_MESSAGE"] = "групповой %s"
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
L["SETTING_SOUNDS"] = "Звуки"
L["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Проигрывать звук когда подходит ваша очередь"
L["ENABLE_TRANQ_NOW_SOUND"] = "Проигрывать звук когда пора использовать Усмиряющий выстрел"
L["TRANQ_NOW_SOUND_CHOICE"] = "Выберите звук для Усмиряющего выстрела"
L["DBM_SOUND_WARNING"] = "DBM проигрывает звук для каждого Бешенства, из-за этого вы можете не устышать оповещение от SilentRotate. Рекомендуется выбрать хорошо различимый звук для SilentRotate или отключить оповещение от DBM"

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
L["SETTING_PROFILES"] = "Профили"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "Очередность Усмиряющего выстрела"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "Очередность Priest MC"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "Очередность Healer Loatheb"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "Очередность Rogue distract"
L["BROADCAST_HEADER_TEXT_FEARWARD"] = "Очередность Fear Ward"
L["BROADCAST_HEADER_TEXT_AOETAUNT"] = "Очередность AoE Taunt"
L["BROADCAST_HEADER_TEXT_MISDI"] = "Очередность Misdirection"
L["BROADCAST_HEADER_TEXT_BLOODLUST"] = "Очередность Bloodlust/Heroism"
L["BROADCAST_ROTATION_PREFIX"] = "Очередность"
L["BROADCAST_BACKUP_PREFIX"] = "Запасные"
