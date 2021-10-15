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
        "Le mode de test durera 60 minutes ou jusqu'a désactivation\n" ..
        "Pour Loatheb, le test consiste à utiliser le débuff Un bandage a été récemment appliqué"
L["ARCANE_SHOT_TESTING_ENABLED"] = "Test mode activé pour 60 minutes"
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
L["NEUTRAL_MESSAGE_LABEL"] = "[%s] Message d'application de l'effet"
L["SUCCESS_MESSAGE_LABEL"] = "[%s] Message de réussite"
L["FAIL_MESSAGE_LABEL"] = "[%s] Message d'échec"

L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"] = "Tir tranquilisant fait sur %s"
L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TIR TRANQUILISANT RATÉ SUR %s !!!"
L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"] = "Psyché corrompue sur %s"
L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"] = "Distraction lancée"
L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"] = "!!! DISTRACTION RATE !!!"
L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"] = "Anti-fear lancé sur %s"
L["DEFAULT_AOETAUNT_SUCCESS_ANNOUNCE_MESSAGE"] = "Taunt de zone pendant 6 secondes !"
L["DEFAULT_AOETAUNT_FAIL_ANNOUNCE_MESSAGE"] = "!!! TAUNT DE ZONE RATE !!!"
L["DEFAULT_MISDI_ANNOUNCE_MESSAGE"] = "Détournement lancé sur %s"
L["DEFAULT_BLOODLUST_ANNOUNCE_MESSAGE"] = "BLOODLUST groupe %s"
L["DEFAULT_GROUNDING_ANNOUNCE_MESSAGE"] = "Totem de glèbe groupe %s"
L["DEFAULT_BREZ_ANNOUNCE_MESSAGE"] = "Battle-rez lancé sur %s"
L["DEFAULT_INNERV_ANNOUNCE_MESSAGE"] = "Innervation lancé sur %s"

L["TRANQ_NOW_LOCAL_ALERT_MESSAGE"] = "TRANQ MAINTENANT !"

L["BROADCAST_MESSAGE_HEADER"] = "Rapport de la configuration de la rotation"
L["USE_MULTILINE_ROTATION_REPORT"] = "Utiliser plusieurs lignes pour la rotation principale"
L["USE_MULTILINE_ROTATION_REPORT_DESC"] = "Chaque chasseur de la rotation apparaitra sur une ligne numérotée"

    --- Modes
L["SETTING_MODES"] = "Modes"
L["FILTER_SHOW_TRANQSHOT"] = "Tranq"
L["FILTER_SHOW_LOATHEB"] = "Horreb"
L["FILTER_SHOW_DISTRACT"] = "Distract"
L["FILTER_SHOW_FEARWARD"] = "Anti-fear"
L["FILTER_SHOW_AOETAUNT"] = "AoE Taunt"
L["FILTER_SHOW_MISDI"] = "Détour"
L["FILTER_SHOW_BLOODLUST"] = "BL"
L["FILTER_SHOW_GROUNDING"] = "Glèbe"
L["FILTER_SHOW_BREZ"] = "B-Rez"
L["FILTER_SHOW_INNERV"] = "Innerv"
L["NO_MODE_AVAILABLE"] = "<Choisissez le mode dans la config>"
L["MODE_INVISIBLE"] = "C'est le mode actuellement sélectionné et il le restera bien que le bouton ne soit plus visible.\nVous souhaitez peut-être cliquer sur un bouton de mode visible afin de sélectionner un autre mode."
L["TRANQSHOT_MODE_FULL_NAME"] = "Tir tranquilisant"
L["LOATHEB_MODE_FULL_NAME"] = "Horreb"
L["DISTRACT_MODE_FULL_NAME"] = "Distraction"
L["FEARWARD_MODE_FULL_NAME"] = "Gardien de peur"
L["AOETAUNT_MODE_FULL_NAME"] = "Provocation de tous les ennemis autour"
L["MISDI_MODE_FULL_NAME"] = "Détournement"
L["BLOODLUST_MODE_FULL_NAME"] = "Furie sanguinaire / Héroïsme"
L["GROUNDING_MODE_FULL_NAME"] = "Totem de glèbe"
L["BREZ_MODE_FULL_NAME"] = "Rez combat"
L["INNERV_MODE_FULL_NAME"] = "Innervation"
L["TRANQSHOT_MODE_DETAILED_DESC"] = "Ce mode détecte quand un boss de raid devient Enragé et prévient les chasseur de lancer la technique Tir tranquilisant."
L["LOATHEB_MODE_DETAILED_DESC"] = "Ce mode détecte la technique de Loatheb qui empêche les soigneurs de lancer des sorts de soin pendant 60 secondes."
L["DISTRACT_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un voleur lance la technique Distraction."
L["FEARWARD_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un prêtre lance le sort Gardien de peur."
L["AOETAUNT_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un guerrier lance la technique Cri de défi ou lorsqu'un druide lance la technique Rugissement provocateur."
L["MISDI_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un chasseur lance la technique Détournement."
L["BLOODLUST_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un chaman lance la technique Furie sanguinaire (Horde) ou Héroïsme (Alliance)."
L["GROUNDING_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un chaman pose un totem de glèbe."
L["BREZ_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un druide ressuscite un joueur avec le sort Renaissance."
L["INNERV_MODE_DETAILED_DESC"] = "Ce mode détecte lorsqu'un druide régénère la mana d'un joueur avec le sort Innervation."
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
L["APPEND_TARGET"] = "Ajouter le nom de la cible"
L["APPEND_TARGET_DESC"] = "Lorsqu'un joueur lance un sort ou une amélioration sur une cible unique, le nom de la cible est ajouté à côté du nom du lanceur de sort ; cette option n'a aucun effet pour les sorts de zone ni pour les cibles non-joueur tels que les monstres"
L["APPEND_TARGET_BUFFONLY"] = "Affiche le nom de la cible uniquement quand le buff est actif"
L["APPEND_TARGET_BUFFONLY_DESC"] = "Le nom de la cible est affiché aussi longtemps que l'amélioration est active sur la cible, puis le nom disparait ; cette option n'a aucun effet pour les modes qui n'utilisent pas de buffs"
L["APPEND_TARGET_NOGROUP"] = "Masquer le numéro de groupe quand il y a un nom de cible"
L["APPEND_TARGET_NOGROUP_DESC"] = "Lorsque le nom de la cible est affiché, le numéro de groupe est masqué temporairement afin de réduire l'enconmbrement de l'affichage"
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

    --- Notifications
L["UPDATE_AVAILABLE"] = "Une nouvelle version est disponible, veuillez mettre à jour pour profiter des dernières fonctionnalités."
L["BREAKING_UPDATE_AVAILABLE"] = "Une mise à jour IMPORTANTE est disponible, vous DEVEZ mettre à jour le plus rapidement possible ! Des conflits sont possibles entre vous et les joueurs qui ont installé la version à jour de SilentRotate."

    --- Profiles
L["SETTING_PROFILES"] = "Profils"

    --- Raid broadcast messages
L["BROADCAST_HEADER_TEXT"] = "[%s] Setup"
L["BROADCAST_ROTATION_PREFIX"] = "Rotation"
L["BROADCAST_BACKUP_PREFIX"] = "Backup"
