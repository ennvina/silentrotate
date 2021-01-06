local L = LibStub("AceLocale-3.0"):NewLocale("SilentRotate", "zhCN", false, false)
if not L then return end
L["LOADED_MESSAGE"] = "SilentRotate 已加载, 输入 /silentrotate 进入设置"
L["TRANQ_WINDOW_HIDDEN"] = "SilentRotate 窗口隐藏. 输入 /silentrotate toggle 显示窗口"

    -- Settings
L["SETTING_GENERAL"] = "一般"
L["SETTING_GENERAL_REPORT"] = "请报告问题: "
L["SETTING_GENERAL_DESC"] = "新内容: SilentRotate 当你需要施放你的宁神射击时，现在将播放一个声音!也有一些显示选项，可以减少插件得干扰。"

L["LOCK_WINDOW"] = "锁定窗口"
L["LOCK_WINDOW_DESC"] = "锁定窗口"
L["HIDE_WINDOW_NOT_IN_RAID"] = "不在团队时隐藏窗口"
L["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "不在团队时隐藏窗口"
L["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "加入团队时隐藏窗口"
L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "如果您不想每次加入团队时都显示窗口，请选中此选项"
L["SHOW_WHEN_TARGETING_BOSS"] = "当你的目标是一个可宁神的Boss时，显示窗口"
L["SHOW_WHEN_TARGETING_BOSS_DESC"] = "当你的目标是一个可宁神的Boss时，显示窗口"
L["WINDOW_LOCKED"] = "SilentRotate: 窗口已隐藏"
L["WINDOW_UNLOCKED"] = "SilentRotate: 窗口已锁定"

L["TEST_MODE_HEADER"] = "测试模式"
L["ENABLE_ARCANE_SHOT_TESTING"] = "切换测试模式"
L["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "当测试模式启用时, 奥术射击将注册为宁神射击\n" ..
        "测试模式将持续10分钟, 除非你提前关闭它\n" ..
        "For Loatheb, testing consists in using the Recently Bandaged as the healer debuff"
L["ARCANE_SHOT_TESTING_ENABLED"] = "奥术射击测试模式已启用, 持续10分钟"
L["ARCANE_SHOT_TESTING_DISABLED"] = "奥术射击测试模式已禁用"

    --- Announces
L["SETTING_ANNOUNCES"] = "通告"
L["ENABLE_ANNOUNCES"] = "启用通告"
L["ENABLE_ANNOUNCES_DESC"] = "启用 / 禁用通告"

    ---- Channels
L["ANNOUNCES_CHANNEL_HEADER"] = "通告频道"
L["MESSAGE_CHANNEL_TYPE"] = "发送到"
L["MESSAGE_CHANNEL_TYPE_DESC"] = "你想发送到哪个频道"
L["MESSAGE_CHANNEL_NAME"] = "频道名或玩家名"
L["MESSAGE_CHANNEL_NAME_DESC"] = "设置目标频道的名称"

    ----- Channels types
L["CHANNEL_CHANNEL"] = "频道"
L["CHANNEL_RAID_WARNING"] = "团队警告"
L["CHANNEL_SAY"] = "说"
L["CHANNEL_YELL"] = "大喊"
L["CHANNEL_PARTY"] = "小队"
L["CHANNEL_RAID"] = "团队"
L["CHANNEL_GUILD"] = "公会"

    ---- Messages
L["ANNOUNCES_MESSAGE_HEADER"] = "通告信息"
L["SUCCESS_MESSAGE_LABEL"] = "施放成功通告信息"
L["FAIL_MESSAGE_LABEL"] = "施放失败通告信息"
L["FAIL_WHISPER_LABEL"] = "施放失败私聊信息"
L["LOATHEB_MESSAGE_LABEL"] = "Loatheb debuff applied"

L["DEFAULT_SUCCESS_ANNOUNCE_MESSAGE"] = "已对 %s 施放了宁神射击!"
L["DEFAULT_FAIL_ANNOUNCE_MESSAGE"] = "!!! 对 %s 宁神失败!!!"
L["DEFAULT_FAIL_WHISPER_MESSAGE"] = "宁神失败 !! 赶紧补宁神!!"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Corrupted Mind on %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "立即使用宁神 !!"

L["TRANQ_SPELL_TEXT"] = "宁神射击"
L["MC_SPELL_TEXT"] = "精神控制"

L["BROADCAST_MESSAGE_HEADER"] = "循环顺序广播频道选择"
L["USE_MULTILINE_ROTATION_REPORT"] = "连续多行发送宁神通告"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "如果您想要更易于理解的顺序显示，请选中此选项"

    --- Modes
L["SETTING_MODES"] = "Modes"
L["FILTER_SHOW_HUNTERS"] = "Tranq"
L["FILTER_SHOW_PRIESTS"] = "Raz"
L["FILTER_SHOW_HEALERS"] = "Loatheb"
L["FILTER_SHOW_ROGUES"] = "Distract"
L["FILTER_SHOW_DWARVES"] = "FearWard"
L["NO_MODE_AVAILABLE"] = "<Choose modes in settings>"
L["MODE_INVISIBLE"] = "This is the currently selected mode and it will stay that way even though the button is not visible.\nYou may want to click a visible button mode in order to select another mode."
L["TRANQ_MODE_FULL_NAME"] = "Tranquilizing Shot"
L["LOATHEB_MODE_FULL_NAME"] = "Loatheb"
L["DISTRACT_MODE_FULL_NAME"] = "Distract"
L["RAZ_MODE_FULL_NAME"] = "Razuvious"
L["FEARWARD_MODE_FULL_NAME"] = "Fear Ward"
L["TRANQ_MODE_DETAILED_DESC"] = "This mode tracks raid bosses when they enter a Frenzy status and tell hunters to cast the Tranquilizing Shot ability."
L["LOATHEB_MODE_DETAILED_DESC"] = "This mode tracks Loatheb's ability that prevents healers from casting healing spells for 60 seconds."
L["DISTRACT_MODE_DETAILED_DESC"] = "This mode tracks whenever a rogue has cast the Distract ability."
L["RAZ_MODE_DETAILED_DESC"] = "This mode tracks priests who are casting Mind Control on Razuvious' adds, a.k.a. Death Knight Understudy."
L["FEARWARD_MODE_DETAILED_DESC"] = "This mode tracks whenever a priest has cast the Fear Ward spell."
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
L["SETTING_SOUNDS"] = "音效"
L["ENABLE_NEXT_TO_TRANQ_SOUND"] = "当下一个宁神射击是您时，播放提示音"
L["ENABLE_TRANQ_NOW_SOUND"] = "当您需要立即宁神射击时，播放提示音"
L["TRANQ_NOW_SOUND_CHOICE"] = "选择要用于“宁神射击”提示的声音"
L["DBM_SOUND_WARNING"] = "DBM在激怒时播放的'flag taken'提示音，可能导致您无法听到SilentRotate的提示音。建议选择一个响亮的提示音，或者在DBM中禁用激怒的警告。"

    --- Profiles
L["SETTING_PROFILES"] = "配置文件"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "猎人宁神顺序"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "Priest MC setup"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "Loatheb Healer setup"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "Rogue distract setup"
L["BROADCAST_HEADER_TEXT_FEARWARD"] = "Fear Ward setup"
L["BROADCAST_ROTATION_PREFIX"] = "循环"
L["BROADCAST_BACKUP_PREFIX"] = "替补"
