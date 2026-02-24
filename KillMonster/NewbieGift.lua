-- NewbieGift.lua (Log File Version - v6 Robust)
-- This script uses a local text file to log and check for newbie gift recipients.

-- Configuration: The name of our log file.
local LOG_FILE_NAME = "newbie_gift_log.txt"

---
-- Checks if a character name and level combination exists in the log file.
-- @param name The character name to search for.
-- @param level The level to check for.
-- @return boolean: true if found, false otherwise.
---
function hasReceivedGift(name, level)
    local file = io.open(LOG_FILE_NAME, "r")
    if not file then
        return false
    end

    -- Create the specific record we are looking for, e.g., "PlayerName,1"
    local record_to_find = name .. "," .. level

    for line in file:lines() do
        -- We perform a direct string comparison, which is very efficient.
        if line:match("^%s*(.-)%s*$") == record_to_find then
            file:close()
            return true -- Found the exact record.
        end
    end

    file:close()
    return false
end

---
-- Appends a character name and their level to the log file.
-- @param name The character name to add.
-- @param level The level of the character when receiving the gift.
---
function recordGiftReceived(name, level)
    local file = io.open(LOG_FILE_NAME, "a")
    if not file then
        LogAdd(2, "[NewbieGift] CRITICAL ERROR: Could not open log file for writing: " .. LOG_FILE_NAME)
        return
    end

    -- Write the record in "name,level" format.
    file:write(name .. "," .. level .. "\n")
    file:close()
end


-- Main function hooked to the character entry event.
function BridgeFunction_OnCharacterEntry(aIndex)
    local player = GetUser(aIndex)

    if player == nil or player.Type ~= 1 then
        return
    end

    -- --- Newbie Gift Logic (Log File Method) ---
    -- We only process level 1 characters. This is our primary, most important check.
    if player.Level == 1 then
        -- Secondary, more robust check against the log file.
        -- We check if a record for this player at this specific level (1) already exists.
        if not hasReceivedGift(player.Name, player.Level) then
            -- Not found in the log, so this is a new recipient.
            LogAdd(3, "[NewbieGift] New recipient found: " .. player.Name .. " at Level 1. Granting gift and logging.")

            -- 1. Grant rewards.
            player.LevelUpPoint = player.LevelUpPoint + 1000
            player.Money = player.Money + 1000000

            -- 2. IMPORTANT: Record the name and level in our log file to prevent future grants.
            recordGiftReceived(player.Name, player.Level)

            -- 3. Update player stats and notify them.
            UserCalcAttribute(aIndex)
            UserInfoSend(aIndex)
            GCNoticeSend(aIndex, 1, "欢迎新玩家！您已获得新手礼包：1000点数和100万金币！")

        else
            -- Found in the log, do nothing about the gift.
            LogAdd(4, "[NewbieGift] Returning player " .. player.Name .. " already in log for Level 1. Skipping gift.")
        end
    end
    -- --- End of Gift Logic ---

    -- Send a standard welcome message regardless of gift status.
    local welcomeMessage = string.format("欢迎您，%s！祝您游戏愉快！", player.Name)
    GCNoticeSend(aIndex, 1, welcomeMessage)
end


-- Attach our function to the server's OnCharacterEntry event.
BridgeFunctionAttach("OnCharacterEntry", "BridgeFunction_OnCharacterEntry")

-- Log a message to confirm the script has been loaded.
LogAdd(4, "[NewbieGift] 新手礼包脚本已成功加载 (v6-增强日志版)。")
