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
        "Режим тестирования работает 10 минут или до отключения\n" ..
        "For Loatheb, testing consists in using the Recently Bandaged as the healer debuff"
L["ARCANE_SHOT_TESTING_ENABLED"] = "Тестовый режим включен на 10 минут"
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
L["SUCCESS_MESSAGE_LABEL"] = "При успехе сообщить"
L["FAIL_MESSAGE_LABEL"] = "При промахе сообщить"
L["FAIL_WHISPER_LABEL"] = "При промахе шепнуть запасным"
L["LOATHEB_MESSAGE_LABEL"] = "Loatheb debuff applied"

L["DEFAULT_SUCCESS_ANNOUNCE_MESSAGE"] = "Усмиряющий выстрел в %s"
L["DEFAULT_FAIL_ANNOUNCE_MESSAGE"] = "!!! Усмиряющий выстрел промах в %s !!!"
L["DEFAULT_FAIL_WHISPER_MESSAGE"] = "!!! Усмиряющий выстрел промах !!! ! СТРЕЛЯЙ СЕЙЧАС !"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Испорченный разум в %s"

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
L["NO_MODE_AVAILABLE"] = "<Choose modes in settings>"
L["MODE_INVISIBLE"] = "This is the currently selected mode and it will stay that way even though the button is not visible.\nYou may want to click a visible button mode in order to select another mode."
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
L["DEFAULT_GROUP_SUFFIX_MESSAGE"] = "групповой %s"
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

    --- Profiles
L["SETTING_PROFILES"] = "Профили"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "Очередность Усмиряющего выстрела"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "Очередность Priest MC"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "Очередность Healer Loatheb"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "Очередность Rogue distract"
L["BROADCAST_ROTATION_PREFIX"] = "Очередность"
L["BROADCAST_BACKUP_PREFIX"] = "Запасные"
