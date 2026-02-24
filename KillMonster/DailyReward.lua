-- ================================================
-- 主逻辑脚本：DailyReward.lua
-- 处理每日登录奖励的核心功能 (已修正玩家账号属性名错误)
-- ================================================

-- 步骤1: 加载我们的配置文件。如果失败，脚本将停止运行并报错。
local config_loaded, config_error = pcall(function()
    murequire("LuaScript.configDailyReward")
end)

if not config_loaded then
    LogAdd(2, "[DailyReward] 致命错误: 无法加载配置文件 configDailyReward.lua! 错误: " .. tostring(config_error))
    return
end

-- 定义日志文件的名字 (遵循NewbieGift.lua的成功模式，不带路径)
local LOG_FILE_NAME = "daily_reward_log.txt"

---
-- 检查一个账号今天是否已经领取过奖励。
-- @param accountId 要查询的账号ID。
-- @return boolean: true 如果今天已领取, false 如果未领取。
---
function hasReceivedToday(accountId)
    local file = io.open(LOG_FILE_NAME, "r")
    if not file then
        return false -- 日志文件还不存在，说明没人领过。
    end

    -- 获取今天的日期字符串，格式为 "年-月-日"
    local today_date = os.date("%Y-%m-%d")
    -- 我们要寻找的记录格式，例如 "MyAccount,2024-02-26"
    local record_to_find = accountId .. "," .. today_date

    for line in file:lines() do
        if line:match("^%s*(.-)%s*$") == record_to_find then
            file:close()
            return true -- 找到了今天的领取记录
        end
    end

    file:close()
    return false -- 遍历了整个文件都没找到
end

---
-- 记录一个账号今天已经领取了奖励。
-- @param accountId 要记录的账号ID。
---
function recordReward(accountId)
    local file = io.open(LOG_FILE_NAME, "a")
    if not file then
        LogAdd(2, "[DailyReward] 严重错误: 无法打开日志文件进行写入: " .. LOG_FILE_NAME)
        return
    end
    
    local today_date = os.date("%Y-%m-%d")
    file:write(accountId .. "," .. today_date .. "\n")
    file:close()
end

---
-- 主函数，挂接到玩家进入游戏的事件
---
function BridgeFunction_OnCharacterEntry(aIndex)
    local player = GetUser(aIndex)

    -- 确保玩家对象存在且是普通玩家角色
    if player == nil or player.Type ~= 1 then
        return
    end

    -- 检查这个账号今天是否已经领过奖了 (已修正为 player.Account)
    if not hasReceivedToday(player.Account) then
        -- === 未领取，开始发放奖励 ===
        LogAdd(3, string.format("[DailyReward] 账号 %s 的角色 %s 是今日首次登录，发放奖励。", player.Account, player.Name))

        -- 1. 发放金币 (如果配置大于0)
        if ConfigDaily.Rewards.Money > 0 then
            player.Money = player.Money + ConfigDaily.Rewards.Money
        end

        -- 2. 发放物品
        if ConfigDaily.Rewards.Items and #ConfigDaily.Rewards.Items > 0 then
            for _, item in ipairs(ConfigDaily.Rewards.Items) do
                ItemGiveEx(aIndex, item.ItemID, item.Level, item.Dur, item.Skill, item.Luck, item.Option, item.Exc, item.Set, 0, 0, 0, 0, 0, 0, 0, 0, 0)
            end
        end

        -- 3. 更新玩家数据到客户端
        UserCalcAttribute(aIndex)
        UserInfoSend(aIndex)

        -- 4. 发送提示消息
        GCNoticeSend(aIndex, 1, ConfigDaily.NoticeMessage)
        
        -- 5. 最重要的一步：立刻写入日志，防止重复领取！(已修正为 player.Account)
        recordReward(player.Account)

    else
        -- === 已领取，静默跳过 === (已修正为 player.Account)
        LogAdd(4, string.format("[DailyReward] 账号 %s 今日已领取过奖励。角色 %s 登录时跳过。", player.Account, player.Name))
    end
end

-- 挂接事件
BridgeFunctionAttach("OnCharacterEntry", "BridgeFunction_OnCharacterEntry")

-- 脚本加载成功日志
LogAdd(4, "[DailyReward] 每日登录奖励脚本 (DailyReward.lua) 已成功加载 (已修正账号属性)。");
