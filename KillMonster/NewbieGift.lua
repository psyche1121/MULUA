-- NewbieGift.lua
-- 当玩家进入游戏时，此脚本会发送一条欢迎信息，并为新玩家提供礼包。

-- 定义当角色进入游戏时要执行的函数
function BridgeFunction_OnCharacterEntry(aIndex)
    -- 从索引获取玩家对象
    local player = GetUser(aIndex)

    -- 确保玩家对象有效并且是一个真实玩家 (Type == 1)
    if player == nil or player.Type ~= 1 then
        return
    end

    -- --- 新手礼包逻辑 ---
    -- 检查是否为1级且从未领取过新手礼包 (GiftNewbiesStatus == 0)
    if player.Level == 1 and player.GiftNewbiesStatus == 0 then
        -- 1. 赠送1000升级点数
        player.LevelUpPoint = player.LevelUpPoint + 1000

        -- 2. 赠送1,000,000金币
        gObjCharacterAddZen(player, 1000000)

        -- 3. 设置标志位，防止重复领取
        player.GiftNewbiesStatus = 1
        
        -- 4. 发送礼包提示信息 (类型1: 右上角)
        GCNoticeSend(aIndex, 1, "欢迎新玩家！您已获得新手礼包：1000点数和100万金币！")
        
        -- 5. 记录服务器日志 (绿色)
        LogAdd(3, "[NewbieGift] 已为新玩家 " .. player.Name .. " 发放新手礼包。")
    end
    -- --- 逻辑结束 ---

    -- 构建并发送常规欢迎信息
    local welcomeMessage = string.format("欢迎您，%s！祝您游戏愉快！", player.Name)
    GCNoticeSend(aIndex, 1, welcomeMessage)

    -- 将操作记录到服务器控制台以进行调试（绿色）
    LogAdd(3, "[NewbieGift] 已为玩家 " .. player.Name .. " 发送私人欢迎信息。")
end

-- 使用 BridgeFunctionAttach 将 OnCharacterEntry 事件挂接到我们定义的函数上
BridgeFunctionAttach("OnCharacterEntry", "BridgeFunction_OnCharacterEntry")

-- 添加一条日志消息，以确认脚本已被服务器加载。
-- 这有助于调试以确保脚本处于活动状态。
-- LogAdd(color, message)
-- 颜色 4 = 蓝色
LogAdd(4, "[NewbieGift] 新手礼包脚本已成功加载并挂接事件。")
