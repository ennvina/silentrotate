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
        "对于洛欧塞布，测试模式将使用绷带的新近包扎作效果为治疗debuff"
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
L["TRANQSHOT_SUCCESS_MESSAGE_LABEL"] = "施放成功通告信息"
L["TRANQSHOT_FAIL_MESSAGE_LABEL"] = "施放失败通告信息"
--L["FAIL_WHISPER_LABEL"] = "施放失败私聊信息"
L["LOATHEB_MESSAGE_LABEL"] = "[洛欧塞布debuff]已获取"
L["DISTRACT_SUCCESS_MESSAGE_LABEL"] = "[扰乱]施放成功通告信息"
L["DISTRACT_FAIL_MESSAGE_LABEL"] = "[扰乱]施放失败通告信息"
L["FEARWARD_MESSAGE_LABEL"] = "[防护恐惧结界]通告信息"
L["AOETAUNT_SUCCESS_MESSAGE_LABEL"] = "[群嘲]施放成功通告信息"
L["AOETAUNT_FAIL_MESSAGE_LABEL"] = "[群嘲]施放失败通告信息"
L["MISDI_MESSAGE_LABEL"] = "Misdirection announce message"

L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"] = "已对 %s 施放了[宁神射击]!"
L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"] = "!!! 对 %s [宁神射击]失败!!!"
L["DEFAULT_TRANQSHOT_FAIL_WHISPER_MESSAGE"] = "[宁神射击]失败 !! 赶紧补宁神!!"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "%s 获得了[堕落心灵]"
L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"] = "[扰乱]完成"
L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"] = "!!! [扰乱]失败 !!!"
L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"] = "已对 %s 施放了[防护恐惧结界]"
L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"] = "[群嘲]已施放，持续6秒!"
L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"] = "!!! [群嘲]失败 !!!"
L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"] = "Misdirection cast on %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "立即使用[宁神射击] !!"

L["TRANQ_SPELL_TEXT"] = "宁神射击"
L["MC_SPELL_TEXT"] = "精神控制"

L["BROADCAST_MESSAGE_HEADER"] = "循环顺序广播频道选择"
L["USE_MULTILINE_ROTATION_REPORT"] = "连续多行发送宁神通告"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "如果您想要以更易于理解的顺序显示，请选中此选项。"

    --- Modes
L["SETTING_MODES"] = "模式"
L["FILTER_SHOW_HUNTERS"] = "宁神"
L["FILTER_SHOW_PRIESTS"] = "教官"
L["FILTER_SHOW_HEALERS"] = "孢子"
L["FILTER_SHOW_ROGUES"] = "扰乱"
L["FILTER_SHOW_DWARVES"] = "防恐"
L["FILTER_SHOW_AOETAUNTERS"] = "群嘲"
L["FILTER_SHOW_MISDIRECTORS"] = "误导"
L["NO_MODE_AVAILABLE"] = "<在设置中选择模式>"
L["MODE_INVISIBLE"] = "这是当前选择的模式，即使按钮不可见，插件也会保持该模式。\n你可能需要单击一个可见按钮才能选择其他模式。"
L["TRANQ_MODE_FULL_NAME"] = "宁神射击"
L["LOATHEB_MODE_FULL_NAME"] = "洛欧塞布"
L["DISTRACT_MODE_FULL_NAME"] = "扰乱"
L["RAZ_MODE_FULL_NAME"] = "教官拉苏维奥斯"
L["FEARWARD_MODE_FULL_NAME"] = "防护恐惧结界"
L["AOETAUNT_MODE_FULL_NAME"] = "群体嘲讽"
L["MISDI_MODE_FULL_NAME"] = "误导"
L["TRANQ_MODE_DETAILED_DESC"] = "此模式会监控团队副本中BOSS的狂暴状态，并通知猎人使用[宁神射击]技能。"
L["LOATHEB_MODE_DETAILED_DESC"] = "此模式会监控洛欧塞布BOSS给治疗职业施放了一个60秒内无法使用治疗技能的[堕落心灵]debuff。"
L["DISTRACT_MODE_DETAILED_DESC"] = "此模式会监控盗贼玩家使用了[扰乱]技能。"
L["RAZ_MODE_DETAILED_DESC"] = "此模式会监控牧师玩家对教官拉苏维奥斯BOSS身边的死亡骑士学员使用了[精神控制]技能。"
L["FEARWARD_MODE_DETAILED_DESC"] = "此模式会监控牧师玩家使用了[防护恐惧结界]技能。"
L["AOETAUNT_MODE_DETAILED_DESC"] = "此模式会监控战士玩家使用了[挑战怒吼]或者德鲁伊玩家使用了[挑战咆哮]技能。"
L["MISDI_MODE_DETAILED_DESC"] = "This mode tracks whenever a hunter has cast the Misdirection ability."
L["MODE_BUTTON_DESC"] = "显示用于激活'%s'模式的按钮。"
L["MODE_LABEL"] = "按钮文本"
L["MODE_LABEL_DESC"] = "在按钮上显示用于激活'%s'模式的文本。"

    --- Names
L["SETTING_NAMES"] = "名字"
L["NAME_TAG_HEADER"] = "名字标签"
L["USE_CLASS_COLOR"] = "职业颜色"
L["USE_CLASS_COLOR_DESC"] = "以职业颜色来着色玩家名字"
L["USE_NAME_OUTLINE"] = "名字轮廓"
L["USE_NAME_OUTLINE_DESC"] = "在名字周围显示黑色的细轮廓"
L["PREPEND_INDEX"] = "显示队列编号"
L["PREPEND_INDEX_DESC"] = "在每个玩家的名字前显示队列编号"
L["INDEX_PREFIX_COLOR"] = "队列编号颜色"
L["INDEX_PREFIX_COLOR_DESC"] = "如果启用了<显示队列编号>，则队列编号文本将被着色"
L["APPEND_GROUP"] = "增加队伍编号"
L["APPEND_GROUP_DESC"] = "在每个玩家的名字后增加所在队伍编号"
L["GROUP_SUFFIX_LABEL"] = "队伍后缀"
L["GROUP_SUFFIX_LABEL_DESC"] = "如果启用了<增加队伍编号>，则队伍后缀就会显示。\n%s 表示编号"
L["GROUP_SUFFIX_COLOR"] = "队伍后缀颜色"
L["GROUP_SUFFIX_COLOR_DESC"] = "如果启用了<增加队伍编号>，则队伍编号文本将被着色。"
L["DEFAULT_GROUP_SUFFIX_MESSAGE"] = "队伍 %s"
L["APPEND_TARGET"] = "Append target name"
L["APPEND_TARGET_DESC"] = "When a player casts a spell or a buff on a single player target, append the name of the target next to the name of the caster; this option has no effect for AoE spells nor for non-player targets, e.g. mobs"
L["APPEND_TARGET_BUFFONLY"] = "Show the target name only while buffed"
L["APPEND_TARGET_BUFFONLY_DESC"] = "The target name is displayed as long as the buff is active on the target, then hide it when the buff fades; this option has no effect for non-buff modes"
L["APPEND_TARGET_NOGROUP"] = "Hide the group number when there is a target name"
L["APPEND_TARGET_NOGROUP_DESC"] = "When the target name is displayed, hide temporarily the group number in order to save space and reduce clutter"
L["BACKGROUND_HEADER"] = "背景"
L["NEUTRAL_BG"] = "标准"
L["NEUTRAL_BG_DESC"] = "单位的标准背景色"
L["ACTIVE_BG"] = "激活"
L["ACTIVE_BG_DESC"] = "循环列表中重点单位（下一位）的背景色"
L["DEAD_BG"] = "死亡"
L["DEAD_BG_DESC"] = "死亡单位的背景色"
L["OFFLINE_BG"] = "离线"
L["OFFLINE_BG_DESC"] = "离线单位的背景色"

    --- Sounds
L["SETTING_SOUNDS"] = "音效"
L["ENABLE_NEXT_TO_TRANQ_SOUND"] = "当下一个宁神射击是您时，播放提示音"
L["ENABLE_TRANQ_NOW_SOUND"] = "当您需要立即宁神射击时，播放提示音"
L["TRANQ_NOW_SOUND_CHOICE"] = "选择要用于“宁神射击”提示的声音"
L["DBM_SOUND_WARNING"] = "DBM在激怒时播放的'flag taken'提示音，可能导致您无法听到SilentRotate的提示音。建议选择一个响亮的提示音，或者在DBM中禁用激怒的警告。"

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
L["SETTING_PROFILES"] = "配置文件"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "猎人宁神顺序"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "牧师心控顺序"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "孢子治疗顺序"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "盗贼扰乱顺序"
L["BROADCAST_HEADER_TEXT_FEARWARD"] = "牧师防恐顺序"
L["BROADCAST_HEADER_TEXT_AOETAUNT"] = "群体嘲讽顺序"
L["BROADCAST_HEADER_TEXT_MISDI"] = "Misdirection setup"
L["BROADCAST_ROTATION_PREFIX"] = "循环"
L["BROADCAST_BACKUP_PREFIX"] = "替补"
