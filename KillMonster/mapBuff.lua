-- ================================================
-- 主逻辑脚本：mapBuff.lua (最终版)
-- 结合了API文档和状态追踪的最终解决方案
-- ================================================

-- 步骤1: 定义我们的“账本”，用于精确追踪玩家获得的地图BUFF
-- Key = aIndex, Value = { MapID = 地图ID }
g_PlayerMapBuffState = g_PlayerMapBuffState or {}

-- 步骤2: 加载配置文件
local config_loaded, config_error = pcall(function()
    murequire("LuaScript.configMapBuff")
end)

if not config_loaded then
    LogAdd(2, "[MapBuff-Final] 致命错误: 无法加载配置文件 configMapBuff.lua! 错误: " .. tostring(config_error))
    return
end

--- 
-- 主函数，在玩家切换地图时触发
--- 
function BridgeFunction_OnMapChange(aIndex, oldMap, newMap)
    local player = GetUser(aIndex)
    if player == nil or player.Type ~= 1 then return end

    LogAdd(3, string.format("[MapBuff-Final] 玩家 %s 变更地图: 从 %d 到 %d", player.Name, oldMap, newMap))
    local needs_update = false -- 标记是否需要刷新属性

    -- 步骤3: 移除旧地图的BUFF
    -- 检查“账本”，确认玩家是否确实拥有旧地图的BUFF
    if g_PlayerMapBuffState[aIndex] and g_PlayerMapBuffState[aIndex].MapID == oldMap then
        local oldBuffs = ConfigMapBuff[oldMap]
        if oldBuffs then
            for _, buff in ipairs(oldBuffs) do
                if player[buff.StatName] ~= nil then
                    player[buff.StatName] = player[buff.StatName] - buff.Value
                    LogAdd(3, string.format("[MapBuff-Final] 移除BUFF: %s, 属性:%s, 值:-%d", player.Name, buff.StatName, buff.Value))
                end
            end
            needs_update = true
            GCNoticeSend(aIndex, 1, "您已离开特殊区域，地图增益已移除。")
        end
        g_PlayerMapBuffState[aIndex] = nil -- 从“账本”中移除记录
    end

    -- 步骤4: 添加新地图的BUFF
    local newBuffs = ConfigMapBuff[newMap]
    if newBuffs then
        if not g_PlayerMapBuffState[aIndex] then
            local first_message = true
            for _, buff in ipairs(newBuffs) do
                if player[buff.StatName] ~= nil then
                    player[buff.StatName] = player[buff.StatName] + buff.Value
                    if first_message then
                        GCNoticeSend(aIndex, 1, buff.Message)
                        first_message = false -- 只发送第一条消息
                    end
                    LogAdd(3, string.format("[MapBuff-Final] 添加BUFF: %s, 属性:%s, 值:+%d", player.Name, buff.StatName, buff.Value))
                else
                    LogAdd(2, string.format("[MapBuff-Final] 警告: 尝试为 %s 添加BUFF失败，属性 '%s' 不存在!", player.Name, buff.StatName))
                end
            end
            g_PlayerMapBuffState[aIndex] = { MapID = newMap } -- 在“账本”上登记
            needs_update = true
        end
    end

    -- 步骤5: 如果有任何属性变更，则调用API刷新玩家数据
    if needs_update then
        UserCalcAttribute(aIndex)
        LogAdd(3, string.format("[MapBuff-Final] 已为玩家 %s 调用 UserCalcAttribute 刷新属性。", player.Name))
    end
end

-- 挂接事件
BridgeFunctionAttach("OnMapChange", "BridgeFunction_OnMapChange")

-- 脚本加载成功日志
LogAdd(4, "[MapBuff] 地图BUFF脚本 [最终版] 已成功加载，一切就绪。");
