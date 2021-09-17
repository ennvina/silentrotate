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
L["TRANQSHOT_SUCCESS_MESSAGE_LABEL"] = "Message de réussite de tir tranquilisant"
L["TRANQSHOT_FAIL_MESSAGE_LABEL"] = "Message d'échec de tir tranquilisant"
--L["FAIL_WHISPER_LABEL"] = "Message d'échec chuchoté"
L["LOATHEB_MESSAGE_LABEL"] = "Message d'application du débuff de Loatheb"
L["DISTRACT_SUCCESS_MESSAGE_LABEL"] = "Message de réussite de distraction"
L["DISTRACT_FAIL_MESSAGE_LABEL"] = "Message d'échec de distraction"
L["FEARWARD_MESSAGE_LABEL"] = "Message d'application de l'anti-fear"
L["AOETAUNT_SUCCESS_MESSAGE_LABEL"] = "Message de réussite de taunt de zone"
L["AOETAUNT_FAIL_MESSAGE_LABEL"] = "Message d'échec de taunt de zone"

L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"] = "Tir tranquilisant fait sur %s"
L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TIR TRANQUILISANT RATÉ SUR %s !!!"
L["DEFAULT_TRANQSHOT_FAIL_WHISPER_MESSAGE"] = "TIR TRANQUILISANT RATE ! TRANQ MAINTENANT !"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Psyché corrompue sur %s"
L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"] = "Distraction lancée"
L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"] = "!!! DISTRACTION RATE !!!"
L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"] = "Anti-fear lancé sur %s"
L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"] = "Taunt de zone pendant 6 secondes !"
L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TAUNT DE ZONE RATE !!!"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "TRANQ MAINTENANT !"

L["TRANQ_SPELL_TEXT"] = "Tir tranquillisant"
L["MC_SPELL_TEXT"] = "Contrôle mental"

L["BROADCAST_MESSAGE_HEADER"] = "Rapport de la configuration de la rotation"
L["USE_MULTILINE_ROTATION_REPORT"] = "Utiliser plusieurs lignes pour la rotation principale"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Chaque chasseur de la rotation apparaitra sur une ligne numérotée"

    --- Modes
L["SETTING_MODES"] = "Modes"
L["FILTER_SHOW_HUNTERS"] = "Tranq"
L["FILTER_SHOW_PRIESTS"] = "Razu"
L["FILTER_SHOW_HEALERS"] = "Horreb"
L["FILTER_SHOW_ROGUES"] = "Distract"
L["FILTER_SHOW_DWARVES"] = "Anti-fear"
L["FILTER_SHOW_AOETAUNTERS"] = "AoE Taunt"
L["NO_MODE_AVAILABLE"] = "<Choisissez le mode dans la config>"
L["MODE_INVISIBLE"] = "C'est le mode actuellement sélectionné et il le restera bien que le bouton ne soit plus visible.\nVous souhaitez peut-être cliquer sur un bouton de mode visible afin de sélectionner un autre mode."
L["TRANQ_MODE_FULL_NAME"] = "Tir tranquilisant"
L["LOATHEB_MODE_FULL_NAME"] = "Horreb"
L["DISTRACT_MODE_FULL_NAME"] = "Distraction"
L["RAZ_MODE_FULL_NAME"] = "Razuvious"
L["FEARWARD_MODE_FULL_NAME"] = "Gardien de peur"
L["AOETAUNT_MODE_FULL_NAME"] = "Provocation de tous les ennemis autour"
L["TRANQ_MODE_DETAILED_DESC"] = "Ce mode détecte quand un boss de raid devient Enragé et prévient les chasseur de lancer la technique Tir tranquilisant."
L["LOATHEB_MODE_DETAILED_DESC"] = "Ce mode détecte la technique de Loatheb qui empêche les soigneurs de lancer des sorts de soin pendant 60 secondes."
L["DISTRACT_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un voleur lance la technique Distraction."
L["RAZ_MODE_DETAILED_DESC"] = "Ce mode suit le Contrôle Mental lancé par les prêtres sur les adds de Razuvious, à savoir les Doublures de chevalier de la mort."
L["FEARWARD_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un prêtre lance le sort Gardien de peur."
L["AOETAUNT_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un guerrier lance la technique Cri de défi ou lorsqu'un druide lance la technique Rugissement provocateur."
L["MODE_BUTTON_DESC"] = "Affiche le bouton pour activer le mode '%s'"
L["MODE_LABEL"] = "Texte du bouton"
L["MODE_LABEL_DESC"] = "Texte écrit dans le bouton pour activer le mode '%s'"

    --- Names
L["SETTING_NAMES"] = "Noms"
L["NAME_TAG_HEADER"] = "Étiquettes"
L["USE_CLASS_COLOR"] = "Colorier les classes"
L["USE_CLASS_COLOR_DESC"] = "Colorier les noms en fonction des classes"
L["USE_NAME_OUTLINE"] = "Détourer les noms"
L["USE_NAME_OUTLINE_DESC"] = "Affiche un liseret noir autour des noms"
L["PREPEND_INDEX"] = "Afficher le numéro de ligne"
L["PREPEND_INDEX_DESC"] = "Affiche le numéro de ligne dans la rotation avant chaque nom de joueur"
L["INDEX_PREFIX_COLOR"] = "Couleur de numéro de ligne"
L["INDEX_PREFIX_COLOR_DESC"] = "Couleur du numéro de la ligne si \"Afficher le numéro de ligne\" est activé"
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

    --- Icons
L["DISPLAY_BLIND_ICON"] = "Afficher une icône pour les joueurs qui n'ont pas installé SilentRotate"
L["DISPLAY_BLIND_ICON_DESC"] = "Ajoute une icône \"aveugle\" sur le joueur pour indiquer qu'il n'utilise pas l'addon. Il/elle ne connaitra pas la rotation affichée et ses actions ne seront pas synchronisées si le joueur se retrouve loin des utilisateurs de l'addon"
L["DISPLAY_BLIND_ICON_TOOLTIP"] = "Afficher l'info-bulle pour l'icône \"aveugle\""
L["DISPLAY_BLIND_ICON_TOOLTIP_DESC"] = "En désactivant cette option vous désactivez l'info-bulle tout en conservant l'icône"

    --- Tooltips
L["TOOLTIP_PLAYER_WITHOUT_ADDON"] = "Ce joueur n'utilise pas SilentRotate"
L["TOOLTIP_MAY_RUN_OUDATED_VERSION"] = "Ou possède une version obsolète, inférieure à 0.7.0"
L["TOOLTIP_DISABLE_SETTINGS"] = "(Vous pouvez désactiver l'icône et/ou l'info-bulle dans les paramètres)"

    --- Profiles
L["SETTING_PROFILES"] = "Profils"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "Setup tranqshot chasseurs"
L["BROADCAST_HEADER_TEXT_RAZUVIOUS"] = "Setup contrôle mental prêtres"
L["BROADCAST_HEADER_TEXT_LOATHEB"] = "Setup soigneurs Loatheb"
L["BROADCAST_HEADER_TEXT_DISTRACT"] = "Setup distraction voleurs"
L["BROADCAST_HEADER_TEXT_FEARWARD"] = "Setup gardien de peur"
L["BROADCAST_HEADER_TEXT_AOETAUNT"] = "Setup taunt de zone"
L["BROADCAST_ROTATION_PREFIX"] = "Rotation"
L["BROADCAST_BACKUP_PREFIX"] = "Backup"
