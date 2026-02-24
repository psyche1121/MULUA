-- PlayerNotice.lua
-- 当玩家进入游戏时，此脚本会发送一条欢迎信息。

-- 定义当角色进入游戏时要执行的函数
function BridgeFunction_OnCharacterEntry(aIndex)
    -- 从索引获取玩家对象
    local player = GetUser(aIndex)

    -- 确保玩家对象有效并且是一个真实玩家 (Type == 1)
    if player == nil or player.Type ~= 1 then
        return
    end

    -- 构建欢迎信息
    -- string.format 是一个标准的 Lua 函数，用于格式化字符串。
    local welcomeMessage = string.format("欢迎您，%s！祝您游戏愉快！", player.Name)

    -- 向该玩家发送私人欢迎信息
    -- GCNoticeSend(aIndex, type, msg)
    -- 类型 1: 通知显示在屏幕右上角。
    GCNoticeSend(aIndex, 1, welcomeMessage)

    -- 将操作记录到服务器控制台以进行调试（绿色）
    LogAdd(3, "[PlayerNotice] 已为玩家 " .. player.Name .. " 发送私人欢迎信息。")
end

-- 使用 BridgeFunctionAttach 将 OnCharacterEntry 事件挂接到我们定义的函数上
BridgeFunctionAttach("OnCharacterEntry", "BridgeFunction_OnCharacterEntry")

-- 添加一条日志消息，以确认脚本已被服务器加载。
-- 这有助于调试以确保脚本处于活动状态。
-- LogAdd(color, message)
-- 颜色 4 = 蓝色
LogAdd(4, "[PlayerNotice] 玩家欢迎公告脚本已成功加载并挂接事件。")
