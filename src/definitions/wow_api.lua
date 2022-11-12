---@meta

---@alias UnitId string

bit = {
    ---binary 'and' - the bitwise and of the values
    ---@param value number
    ---@param ... number
    ---@return number
    band = function(value, ...) end
}

COMBATLOG_OBJECT_AFFILIATION_MINE     = 0x00000001
COMBATLOG_OBJECT_AFFILIATION_PARTY    = 0x00000002
COMBATLOG_OBJECT_AFFILIATION_RAID     = 0x00000004
COMBATLOG_OBJECT_AFFILIATION_OUTSIDER = 0x00000008
COMBATLOG_OBJECT_AFFILIATION_MASK     = 0x0000000F

AuraUtil = {
    ---@param unit UnitId
    ---@param filter string -- A list of filters, separated by pipe chars or spaces. Otherwise defaults to "HELPFUL".
    ---@param maxCount integer? -- The maximum number of slots to iterate over
    ---@param func fun(...): boolean
    ---@param usePackedAura boolean -- If `true`, this function passes the result of `C_UnitAuras.GetAuraDataBySlot` to `func`, instead of the result of `UnitAuraBySlot`.
    ForEachAura = function(unit, filter, maxCount, func, usePackedAura) end
}

---Returns the system uptime of your computer in seconds, with millisecond precision.
---@return number time -- The current system uptime in seconds, e.g. 60123.558
---@nodiscard
function GetTime() end

---Returns the server's Unix time.
---@return number timestamp Time in seconds since the epoch.
---@nodiscard
function GetServerTime() end

---@param unit UnitId
---@return boolean exists -- true if the unit exists and is in the current zone, or false if not
---@nodiscard
function UnitExists(unit) end

---Returns true if the first unit can attack the second, false otherwise.
---@param attacker UnitId -- the unit that would initiate the attack
---@param attacked UnitId -- the unit that would be attacked
---@return boolean canAttack -- true if the attacker can attack the attacked, false otherwise.
---@nodiscard
function UnitCanAttack(attacker, attacked) end

---True if the unit is dead.
---@param unit UnitId
---@return boolean isDead
---@nodiscard
function UnitIsDead(unit) end

---Returns the current health of the unit.
---@param unit UnitId
---@return number health -- Returns `0` if the unit is dead or does not exist.
---@nodiscard
function UnitHealth(unit) end

---Returns the maximum health of the unit.
---@param unit UnitId
---@return number maxHealth -- Returns `0` if the unit does not exist.
---@nodiscard
function UnitHealthMax(unit) end

---Returns the GUID of the unit.
---@param unit UnitId
---@return string? guid A string containing (hexadecimal) values, delimited with hyphens. Returns `nil` if the unit does not exist.
---@nodiscard
function UnitGUID(unit) end

---Returns the cooldown info of a spell.
---@param spell number|string -- Spell ID or Name. When passing a name requires the spell to be in your Spellbook.
---@return number startTime -- The time when the cooldown started as returned by `GetTime()`; `0` if no cooldown; current time if `enabled == 0`.
---@return number duration -- Cooldown duration in seconds, 0 if spell is ready to be cast.
---@return 0|1 enabled -- `0` if the spell is active (Stealth, Shadowmeld, Presence of Mind, etc) and the cooldown will begin as soon as the spell is used/cancelled; `1` otherwise.
---@return number modRate -- The rate at which the cooldown widget's animation should be updated.
---@nodiscard
function GetSpellCooldown(spell) end

BOOKTYPE_SPELL = "spell"
BOOKTYPE_PET = "pet"
---@alias BookType `BOOKTYPE_SPELL`|`BOOKTYPE_PET`

---Returns the cooldown info of a spell.
---@param index number -- Spellbook slot index, ranging from 1 through the total number of spells across all tabs and pages.
---@param bookType BookType -- `BOOKTYPE_SPELL` or `BOOKTYPE_PET` depending on if you wish to query the player or pet spellbook.
---@return number startTime -- The time when the cooldown started as returned by `GetTime()`; `0` if no cooldown; current time if `enabled == 0`.
---@return number duration -- Cooldown duration in seconds, 0 if spell is ready to be cast.
---@return 0|1 enabled -- `0` if the spell is active (Stealth, Shadowmeld, Presence of Mind, etc) and the cooldown will begin as soon as the spell is used/cancelled; `1` otherwise.
---@return number modRate -- The rate at which the cooldown widget's animation should be updated.
---@nodiscard
function GetSpellCooldown(index, bookType) end

LE_PARTY_CATEGORY_HOME = 1
LE_PARTY_CATEGORY_INSTANCE = 2

---True if the player is in a raid
---@param groupType `LE_PARTY_CATEGORY_HOME`|`LE_PARTY_CATEGORY_INSTANCE`? provide to check for a specific type of group
---@return boolean isInRaid `true` if the player is currently in a `groupType` raid group (if `groupType` was not specified, `true` if in any type of raid), false otherwise
function IsInRaid(groupType) end

---Returns whether the player has learned a particular spell.
---@param spellID number Spell ID of the spell to query
---@return boolean isKnown `true` if the player can cast this spell (or a different spell that overrides this spell), `false` otherwise
function IsPlayerSpell(spellID) end

---Returns whether the player (or pet) knows the given spell.
---@param spellID number Spell ID of the spell to query
---@param isPetSpell boolean? if `true`, will check if the currently active pet knows the spell; if false or omitted, will check if the player knows the spell
---@return boolean isKnown whether the player (or pet) knows the given spell
function IsSpellKnown(spellID, isPetSpell) end

C_Timer = {}

---Schedules a timer.
---@param seconds number -- Time in seconds before the timer finishes.
---@param callback fun() -- Callback function to run.
function C_Timer.After(seconds, callback) end
