## SilentRotate Changelog

#### v1.0.2 (2024-03-07)

- Updated ACE3 libraries to newest version
- Fixed a few issues with the 1.15.1 client.

#### v1.0.1 (2022-05-11)

- Older versions should no longer cause a lua error to newer versions

#### v1.0.0 (2022-04-23)

After more tests, the addon is ready to leave its Beta phase

- Players can be assigned to other players
- Right-click on a player's frame to select its assignment
- The tooltip indicates the assignment
- The tooltip also displays the name of the last target
- New option for players who want to match their focus to their assignment
- The addon version should no longer fail to be shared between players
- Added TOC file to Retail, for testing purposes - use it at your own risk

#### v0.9.4-beta (2022-01-25)

- Added Scorpid Sting mode (TBC), currently enabled for:
- Archimonde, Supremus, Teron, Gurtogg, Shahraz, Gathios and Illidan

#### v0.9.3-beta (2022-01-15)

- Added Ritual of Souls mode (TBC)
- Classic Era now completely ignores TBC modes, instead of just hiding them
- Tranqshot and Loatheb require a raid, other modes work in dungeons as well

#### v0.9.2-beta (2021-11-07)

- Added Soulstone mode
- Changing modes no longer requires to be out-of-combat
- Option to setup the local alert when the previous player failed
- Grounding Totem History detects when the shaman dies
- Grounding Totem History detects when the group of the shaman is changed

#### v0.9.1-beta (2021-10-30)

- Added Blessing of Protection mode
- Added Blessing of Freedom mode
- Tooltip shows effect duration and cooldown remaining time
- History displays effect expiration and early removal, only for buffs
- History no longer displays a "consumed" message too early
- Mouseover the Blind icon no longer causes an error
- Loatheb mode no longer fails to detect Corrupted Mind debuff
- Tranqshot mode no longer fails to detect when Tranqshot is cast

#### v0.9.0-beta (2021-10-25)

Major changes have been done to the window system
Because of that, the window position and size have been reset

- New button in the title bar to display History
- Buttons in the title bar are sligthly bigger and now have a tooltip
- The Settings button now toggles the window instead of always opening it
- If the main window was hidden by the user, it is not reopen on startup
- Window width is changed by a resizer in the window instead of settings
- History has its own new tab in the Settings window

#### v0.8.1-beta (2021-10-22)

- Added Innervate mode
- Grounding totem now tracks which spell destroyed the totem
- Mouseover the shaman name to know who and when was destroyed the totem
- Window width can be changed in Settings > General

#### v0.8.0-beta (2021-10-15)

The code was reworked to improve performance and make it easier to maintain
Because of that, some options may have reset to their default value

- Added Bloodlust mode (TBC)
- Added Grounding Totem mode
- Added Battle Rez mode
- Testing time increased to 60 minutes (up from 10 minutes)
- Razuvious mode no longer exists, it was hidden since forever anyway
- Support for Multi-TOC files (Vanilla and TBC)

#### v0.7.1-beta (2021-09-19)

- Display a tick in the cooldown bar for the duration of the buff or effect
- Option to append the target name next to the caster (enabled by default)

#### v0.7.0-beta (2021-09-18)

ALL USERS MUST UPDATE THE ADDON

because the update fixes critical issues for Classic Era as well as
The Burning Crusade Classic, and because the fixes will break the
compatibility between this version and older versions

- Fixed cross-realm names (Era)
- Fixed drag'n'drop issue (TBC)
- Added Misdirection mode (TBC)
- Fear Ward cooldown adapts to the project ID (Era = 30 secs; TBC = 3 min)
- AoE Taunt messages are now customizable
- The addon version is now shared between players in the same raid
- A Blind icon is displayed next to players who have not installed the addon
- Players with SilentRotate prior to v0.7 will be NOT be detected
- Users are notified when a new version is available
- "/sr check" or "/sr version" checks the addon version of yourself and others
- "/sr show" and "/sr hide" will show/hide the SilentRotate window
- Updated Chinese translations (zh-CN)
- Updated Ace libraries to their latest version (30-jun-2021)

#### v0.6.3-beta (2021-01-28)

- Added AoE Taunt mode

#### v0.6.2-beta (2021-01-27)

- Option to preprend player index in the rotation
- Updated Chinese translations (zh-CN)

#### v0.6.1-beta (2021-01-25)

- All modes now send messages
- This will fix some issues if an event happens more than 45 yards away

#### v0.6.0-beta (2021-01-25)

- Everyone is invited to update the addon in order to avoid conflicts
- All modes now share the same comm prefix
- The lua error of 'receiveSyncTranq' should no longer happen
- When a rogue misses a distract, an alert is sent to the next rogue

#### v0.5.0-beta (2021-01-06)

- New mode: Fear Ward

#### v0.4.1-beta (2020-12-23)

- The selected mode is now stored in user settings
- Options to enable which modes are selectable
- By default, modes are selectable based on your class

#### v0.4.0-beta (2020-12-23)

- Name tags are now customizable
- Option to enable class colors
- Option to append group index, plus options to choose its text and color
- Options to select the background colors (neutral, active, dead, offline)

#### v0.3.5-beta (2020-12-23)

- Activating Test mode will now show your own unit even if not in a raid group
- Activating Test mode will now show party units even if not in a raid group
- Either way Test mode will only show units which class fits the selected mode

#### v0.3.4-beta (2020-12-22)

- Text color is now based on the class color, instead of white
- The default background color is now light-gray, instead of green
- The background was green because the addon initially focused on hunters

#### v0.3.3-beta (2020-12-18)

- After more tests, the addon is qualified as Beta

#### v0.3.2-alpha (2020-12-16)

- Fixed Loatheb tracking of other units due to WoW Classic limitation
- Reset Loatheb tracking in case of events such as player death

#### v0.3.1-alpha (2020-12-15)

- Localization should now be compatible with CurseForge
- Added missing translations for ru-RU, zh-CN and zh-TW
- Phrases use the English version until they are properly translated

#### v0.3.0-alpha (2020-12-14)

- SilentRotate is now public!
- Addon hosted on Curse https://www.curseforge.com/wow/addons/silentrotate
- Source code is available on GitHub https://github.com/ennvina/silentrotate
- This release mostly focuses on cleaning up some files before sharing them

#### v0.2.0-alpha (2020-12-08)

- Modes have been renamed to Tranq, Raz and Loatheb
- New mode: Distract, for rogues’s Distract rotation
- Distract mode can be tested outside an instance by simply casting Distract
- Raz mode is hidden for now, until the functionality is coded (or dropped)
- Mode is selected automatically upon login, depending on the current class
- Loatheb mode now tracks Corrupted Mind’s spell ID instead of spell name
- Fixed a bug with how lists are refreshed when switching modes
- Each mode now has its own comm prefix to prevent conflict between modes

#### v0.1.0-alpha (2020-12-07)

- Fork from TranqRotate
- Added buttons for choosing mode: Hunter, Priest, Healer
- Changing mode affects which classes are displayed in the main window
- Healer mode tracks the Corrupted Mind debuff on Loatheb
- Healer mode can be tested through the Recently Bandaged debuff
- Razuvious is a filler mode only and does do anything yet
