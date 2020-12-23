local L = LibStub("AceLocale-3.0"):NewLocale("SilentRotate", "frFR", false, false)
if not L then return end
L["LOADED_MESSAGE"] = "SilentRotate chargé, utilisez /silentrotate pour les options"
L["TRANQ_WINDOW_HIDDEN"] = "SilentRotate window hidden. Use /silentrotate toggle to get it back"

    -- Settings
L["SETTING_GENERAL"] = "Général"
L["SETTING_GENERAL_REPORT"] = "Merci de signaler tout bug rencontré sur"
L["SETTING_GENERAL_DESC"] = "Nouveau : SilentRotate peut maintenant jouer un son pour vous avertir quand vous devez tranq ! Plusieurs optiosn d'affichage ont été ajoutée pour rendre l'addon moins intrusif"

L["LOCK_WINDOW"] = "Verrouiller la position de la fênetre"
L["LOCK_WINDOW_DESC"] = "Verrouiller la position de la fênetre"
L["HIDE_WINDOW_NOT_IN_RAID"] = "Masquer la fenêtre principale hors raid"
L["HIDE_WINDOW_NOT_IN_RAID_DESC"] = "Masquer la fenêtre principale hors raid"
L["DO_NOT_SHOW_WHEN_JOINING_RAID"] = "Ne pas afficher la fenêtre principale lorsque vous rejoignez un raid"
L["DO_NOT_SHOW_WHEN_JOINING_RAID_DESC"] = "Ne pas afficher la fenêtre principale lorsque vous rejoignez un raid"
L["SHOW_WHEN_TARGETING_BOSS"] = "Afficher la fenêtre principale lorsque vous ciblez un boss tranquilisable"
L["SHOW_WHEN_TARGETING_BOSS_DESC"] = "Afficher la fenêtre principale lorsque vous ciblez un boss tranquilisable"
L["WINDOW_LOCKED"] = "SilentRotate: Fenêtre verrouillée"
L["WINDOW_UNLOCKED"] = "SilentRotate: Fenêtre déverrouillée"

L["TEST_MODE_HEADER"] = "Test mode"
L["ENABLE_ARCANE_SHOT_TESTING"] = "Activer/désactiver le mode test"
L["ENABLE_ARCANE_SHOT_TESTING_DESC"] =
        "Tant que le mode de test est activé, arcane shot sera considéré comme un tir tranquilisant\n" ..
        "Le mode de test durera 10 minutes ou jusqu'a désactivation\n" ..
        "Pour Loatheb, le test consiste à utiliser le débuff Un bandage a été récemment appliqué"
L["ARCANE_SHOT_TESTING_ENABLED"] = "Test mode activé pour 10 minutes"
L["ARCANE_SHOT_TESTING_DISABLED"] = "Test mode désactivé"

    --- Announces
L["SETTING_ANNOUNCES"] = "Annonces"
L["ENABLE_ANNOUNCES"] = "Activer les annonces"
L["ENABLE_ANNOUNCES_DESC"] = "Activer / désactiver les annonces"

    ---- Channels
L["ANNOUNCES_CHANNEL_HEADER"] = "Canal"
L["MESSAGE_CHANNEL_TYPE"] = "Canal"
L["MESSAGE_CHANNEL_TYPE_DESC"] = "Canal à utiliser pour les annonces"
L["MESSAGE_CHANNEL_NAME"] = "Nom du canal"
L["MESSAGE_CHANNEL_NAME_DESC"] = "Nom du canal à utiliser"

    ----- Channels types
L["CHANNEL_CHANNEL"] = "Channel"
L["CHANNEL_RAID_WARNING"] = "Avertissement raid"
L["CHANNEL_SAY"] = "Dire"
L["CHANNEL_YELL"] = "Crier"
L["CHANNEL_PARTY"] = "Groupe"
L["CHANNEL_RAID"] = "Raid"
L["CHANNEL_GUILD"] = "Guilde"

    ---- Messages
L["ANNOUNCES_MESSAGE_HEADER"] = "Annonces de tir tranquilisant"
L["SUCCESS_MESSAGE_LABEL"] = "Message de réussite"
L["FAIL_MESSAGE_LABEL"] = "Message d'échec"
L["FAIL_WHISPER_LABEL"] = "Message d'échec chuchoté"
L["LOATHEB_MESSAGE_LABEL"] = "Message d'application du débuff de Loatheb"

L["DEFAULT_SUCCESS_ANNOUNCE_MESSAGE"] = "Tir tranquilisant fait sur %s"
L["DEFAULT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TIR TRANQUILISANT RATÉ SUR %s !!!"
L["DEFAULT_FAIL_WHISPER_MESSAGE"] = "TIR TRANQUILISANT RATE ! TRANQ MAINTENANT !"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Psyché corrompue sur %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "TRANQ MAINTENANT !"

L["TRANQ_SPELL_TEXT"] = "Tir tranquillisant"
L["MC_SPELL_TEXT"] = "Contrôle mental"

L["BROADCAST_MESSAGE_HEADER"] = "Rapport de la configuration de la rotation"
L["USE_MULTILINE_ROTATION_REPORT"] = "Utiliser plusieurs lignes pour la rotation principale"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Chaque chasseur de la rotation apparaitra sur une ligne numérotée"

    --- Modes
L["FILTER_SHOW_HUNTERS"] = "Tranq"
L["FILTER_SHOW_PRIESTS"] = "Razu"
L["FILTER_SHOW_HEALERS"] = "Horreb"
L["FILTER_SHOW_ROGUES"] = "Distract"

    --- Names
L["SETTING_NAMES"] = "Noms"
L["NAME_TAG_HEADER"] = "Étiquettes"
L["USE_CLASS_COLOR"] = "Colorier les classes"
L["USE_CLASS_COLOR_DESC"] = "Colorier les noms en fonction des classes"
L["USE_NAME_OUTLINE"] = "Détourer les noms"
L["USE_NAME_OUTLINE_DESC"] = "Affiche un liseret noir autour des noms"
L["APPEND_GROUP"] = "Ajouter le numéro de groupe"
L["APPEND_GROUP_DESC"] = "Ajouter le numéro de groupe à côté de chaque nom de joueur"
L["GROUP_SUFFIX_LABEL"] = "Suffixe de groupe"
L["GROUP_SUFFIX_LABEL_DESC"] = "Label utilisé pour le numéro de groupe si \"Ajouter le numéro de groupe\" est activé.\n%s désigne le numéro"
L["GROUP_SUFFIX_COLOR"] = "Couleur de suffixe de groupe"
L["GROUP_SUFFIX_COLOR_DESC"] = "Couleur utilisée pour le numéro de groupe si \"Ajouter le numéro de groupe\" est activé"
L["DEFAULT_GROUP_SUFFIX_MESSAGE"] = "groupe %s"
L["BACKGROUND_HEADER"] = "Couleurs de fond"
L["NEUTRAL_BG"] = "Neutre"
L["NEUTRAL_BG_DESC"] = "Couleur de fond standard pour les unités"
L["ACTIVE_BG"] = "Actif"
L["ACTIVE_BG_DESC"] = "Couleur de fond pour l'unité qui doit agir dans la rotation"
L["DEAD_BG"] = "Mort"
L["DEAD_BG_DESC"] = "Couleur de fond pour les unités décédées"
L["OFFLINE_BG"] = "Hors ligne"
L["OFFLINE_BG_DESC"] = "Couleur de fond pour les unités déconnectées"

    --- Sounds
L["SETTING_SOUNDS"] = "Sons"
L["ENABLE_NEXT_TO_TRANQ_SOUND"] = "Jouer un son lorsque vous êtes le prochain à devoir tranq"
L["ENABLE_TRANQ_NOW_SOUND"] = "Jouer un son au moment ou vous devez tranq"
L["TRANQ_NOW_SOUND_CHOICE"] = "Son à jouer au moment ou vous devez tranq"
L["DBM_SOUND_WARNING"] = "DBM joue le son de capture de drapeau à chaque frénésie, cela pourrait couvrir un son trop doux. Je suggère de choisir un son assez marquant ou de désactiver les alertes de frénésie DBM si vous choisissez un son plus doux."

    --- Profiles
L["SETTING_PROFILES"] = "Profils"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "Setup tranqshot chasseurs"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "Setup contrôle mental prêtres"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "Setup soigneurs Loatheb"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "Setup distraction voleurs"
L["BROADCAST_ROTATION_PREFIX"] = "Rotation"
L["BROADCAST_BACKUP_PREFIX"] = "Backup"
