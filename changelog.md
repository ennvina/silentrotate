## SilentRotate Changelog

#### v0.4.1-beta

- The selected mode is now stored in user settings
- Options to enable which modes are selectable
- By default, modes are selectable based on your class

#### v0.4.0-beta

- Name tags are now customizable
- Option to enable class colors
- Option to append group index, plus options to choose its text and color
- Options to select the background colors (neutral, active, dead, offline)

#### v0.3.5-beta

- Activating Test mode will now show your own unit even if not in a raid group
- Activating Test mode will now show party units even if not in a raid group
- Either way Test mode will only show units which class fits the selected mode

#### v0.3.4-beta

- Text color is now based on the class color, instead of white
- The default background color is now light-gray, instead of green
- The background was green because the addon initially focused on hunters

#### v0.3.3-beta

- After more tests, the addon is qualified as Beta

#### v0.3.2-alpha

- Fixed Loatheb tracking of other units due to WoW Classic limitation
- Reset Loatheb tracking in case of events such as player death

#### v0.3.1-alpha

- Localization should now be compatible with CurseForge
- Added missing translations for ru-RU, zh-CN and zh-TW
- Phrases use the English version until they are properly translated

#### v0.3.0-alpha

- SilentRotate is now public!
- Addon hosted on Curse https://www.curseforge.com/wow/addons/silentrotate
- Source code is available on GitHub https://github.com/ennvina/silentrotate
- This release mostly focuses on cleaning up some files before sharing them

#### v0.2.0-alpha

- Modes have been renamed to Tranq, Raz and Loatheb
- New mode: Distract, for rogues’s Distract rotation
- Distract mode can be tested outside an instance by simply casting Distract
- Raz mode is hidden for now, until the functionality is coded (or dropped)
- Mode is selected automatically upon login, depending on the current class
- Loatheb mode now tracks Corrupted Mind’s spell ID instead of spell name
- Fixed a bug with how lists are refreshed when switching modes
- Each mode now has its own comm prefix to prevent conflict between modes

#### v0.1.0-alpha

- Fork from TranqRotate
- Added buttons for choosing mode: Hunter, Priest, Healer
- Changing mode affects which classes are displayed in the main window
- Healer mode tracks the Corrupted Mind debuff on Loatheb
- Healer mode can be tested through the Recently Bandaged debuff
- Razuvious is a filler mode only and does do anything yet
