-- lfm.lua

-- Define dungeons with an "Any" option using your provided list.
local dungeons = {
  ["Any"]                        = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["Operation: Floodgate"]       = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["Cinderbrew Meadery"]         = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["Darkflame Cleft"]            = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["The Rookery"]                = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["Priory of the Sacred Flame"] = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["The MOTHERLODE!!"]           = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["Theater of Pain"]            = {"Normal", "Heroic", "Mythic", "Mythic+"},
  ["Operation: Mechagon: Workshop"] = {"Normal", "Heroic", "Mythic", "Mythic+"}
};

-- Define roles.
local roles = {"Tank", "Healer", "DPS"};

-- Define levels as "N/A" plus numbers 0 to 20, skipping 1.
local levels = {"N/A"}
for i = 0, 20 do
  if i ~= 1 then
      table.insert(levels, tostring(i))
  end
end

-- Variables to store user selections.
lfm_SelectedDungeon = nil;
lfm_SelectedDifficulty = nil;
lfm_SelectedRole = nil;
lfm_SelectedLevel = nil;

------------------------------------------------------------
-- Update Difficulty dropdown based on selected dungeon.
------------------------------------------------------------
function UpdateDifficultyDropdown()
  local dungeon = lfm_SelectedDungeon;
  if not dungeon or not dungeons[dungeon] then return end;
  lfm_SelectedDifficulty = nil;
  UIDropDownMenu_SetText(LFMFrameDifficultyDropdown, "Select Difficulty");
  UIDropDownMenu_Initialize(LFMFrameDifficultyDropdown, function(self, level, menuList)
      for _, diff in ipairs(dungeons[dungeon]) do
          local info = UIDropDownMenu_CreateInfo();
          info.text = diff;
          info.func = function(self)
              lfm_SelectedDifficulty = self.value;
              UIDropDownMenu_SetText(LFMFrameDifficultyDropdown, self.value);
          end;
          info.value = diff;
          UIDropDownMenu_AddButton(info);
      end
  end);
end

------------------------------------------------------------
-- Dungeon Dropdown Initialization.
------------------------------------------------------------
function lfm_DungeonDropdown_OnLoad(self)
  UIDropDownMenu_SetWidth(self, 120);
  UIDropDownMenu_SetText(self, "Select Dungeon");
  UIDropDownMenu_Initialize(self, function(self, level, menuList)
      for dungeon, _ in pairs(dungeons) do
          local info = UIDropDownMenu_CreateInfo();
          info.text = dungeon;
          info.func = function(self)
              lfm_SelectedDungeon = self.value;
              UIDropDownMenu_SetText(LFMFrameDungeonDropdown, self.value);
              UpdateDifficultyDropdown();
          end;
          info.value = dungeon;
          UIDropDownMenu_AddButton(info);
      end
  end);
end

------------------------------------------------------------
-- Difficulty Dropdown Initialization.
------------------------------------------------------------
function lfm_DifficultyDropdown_OnLoad(self)
  UIDropDownMenu_SetWidth(self, 120);
  UIDropDownMenu_SetText(self, "Select Difficulty");
  -- This dropdown is reinitialized when a dungeon is selected.
end

------------------------------------------------------------
-- Role Dropdown Initialization.
------------------------------------------------------------
function lfm_RoleDropdown_OnLoad(self)
  UIDropDownMenu_SetWidth(self, 120);
  UIDropDownMenu_SetText(self, "Select Role");
  UIDropDownMenu_Initialize(self, function(self, level, menuList)
      for _, role in ipairs(roles) do
          local info = UIDropDownMenu_CreateInfo();
          info.text = role;
          info.func = function(self)
              lfm_SelectedRole = self.value;
              UIDropDownMenu_SetText(LFMFrameRoleDropdown, self.value);
          end;
          info.value = role;
          UIDropDownMenu_AddButton(info);
      end
  end);
end

------------------------------------------------------------
-- Level Dropdown Initialization.
------------------------------------------------------------
function lfm_LevelDropdown_OnLoad(self)
  UIDropDownMenu_SetWidth(self, 120);
  UIDropDownMenu_SetText(self, "Select Level");
  UIDropDownMenu_Initialize(self, function(self, level, menuList)
      for _, lvl in ipairs(levels) do
          local info = UIDropDownMenu_CreateInfo();
          info.text = lvl;
          info.func = function(self)
              lfm_SelectedLevel = self.value;
              UIDropDownMenu_SetText(LFMFrameLevelDropdown, self.value);
          end;
          info.value = lvl;
          UIDropDownMenu_AddButton(info);
      end
  end);
end

------------------------------------------------------------
-- Generate Button Click Handler.
------------------------------------------------------------
function lfm_GenerateButton_OnClick()
  if not lfm_SelectedDungeon or not lfm_SelectedDifficulty or not lfm_SelectedRole or not lfm_SelectedLevel then
      print("Please make all selections before generating the command.");
      return;
  end
  local command = string.format("/lfm difficulty:%s dungeon:%s level:%s role:%s",
      lfm_SelectedDifficulty, lfm_SelectedDungeon, lfm_SelectedLevel, lfm_SelectedRole);
  LFMFrameOutputBox:SetText(command);
  LFMFrameOutputBox:SetFocus();
  LFMFrameOutputBox:HighlightText();
  print("Generated Command: " .. command);
end

-- Slash command to open the UI.
SLASH_LFM1 = "/lfm";
SlashCmdList["LFM"] = function(msg)
  LFMFrame:Show();
end
