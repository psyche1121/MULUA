-- ================================================
-- 主逻辑脚本：mapBuff.lua (最终版 v3 - 效果系统)
-- 使用 AddEffect/DelEffect 来确保属性加成被游戏引擎正确识别
-- ================================================

-- 步骤1: 加载配置文件
local config_loaded, config_error = pcall(function()
    murequire("LuaScript.configMapBuff")
end)

if not config_loaded then
    LogAdd(2, "[MapBuff-Effect] 致命错误: 无法加载配置文件 configMapBuff.lua! 错误: " .. tostring(config_error))
    return
end

---
-- 主函数，在玩家切换地图时触发
---
function BridgeFunction_OnMapChange(aIndex, oldMap, newMap)
    local player = GetUser(aIndex)
    if player == nil or player.Type ~= 1 then return end

    LogAdd(3, string.format("[MapBuff-Effect] 玩家 %s 变更地图: 从 %d 到 %d", player.Name, oldMap, newMap))

    -- 步骤2: 移除旧地图的BUFF
    local oldBuffConfig = ConfigMapBuff[oldMap]
    if oldBuffConfig then
        if CheckEffect(player, oldBuffConfig.EffectID) then
            DelEffect(player, oldBuffConfig.EffectID)
            GCNoticeSend(aIndex, 1, "你感觉地图的神秘力量消失了。")
            LogAdd(3, string.format("[MapBuff-Effect] 成功为 %s 移除了效果ID: %d", player.Name, oldBuffConfig.EffectID))
        end
    end

    -- 步骤3: 添加新地图的BUFF
    local newBuffConfig = ConfigMapBuff[newMap]
    if newBuffConfig then
        if not CheckEffect(player, newBuffConfig.EffectID) then
            -- 根据API文档，调用AddEffect并传入所有参数
            AddEffect(player, newBuffConfig.EffectID, newBuffConfig.Time, newBuffConfig.Value1, newBuffConfig.Value2, newBuffConfig.Value3, newBuffConfig.Value4)
            GCNoticeSend(aIndex, 1, newBuffConfig.Message)
            LogAdd(3, string.format("[MapBuff-Effect] 成功为 %s 添加效果ID: %d, 值1:%d, 值2:%d", player.Name, newBuffConfig.EffectID, newBuffConfig.Value1, newBuffConfig.Value2))
        end
    end
    
    -- AddEffect/DelEffect 通常会自动刷新属性，无需手动调用 UserCalcAttribute
end

-- 步骤4: 在玩家掉线时，清除可能存在的地图BUFF，防止bug
function BridgeFunction_OnCharacterClose(aIndex)
    local player = GetUser(aIndex)
    if player == nil or player.Type ~= 1 then return end

    for mapID, buffConfig in pairs(ConfigMapBuff) do
        if CheckEffect(player, buffConfig.EffectID) then
            DelEffect(player, buffConfig.EffectID)
            LogAdd(3, string.format("[MapBuff-Effect] 玩家 %s 掉线，已清理效果ID: %d", player.Name, buffConfig.EffectID))
        end
    end
end


-- 步骤5: 挂接事件
BridgeFunctionAttach("OnMapChange", "BridgeFunction_OnMapChange")
BridgeFunctionAttach("OnCharacterClose", "BridgeFunction_OnCharacterClose") -- 新增：处理玩家掉线

-- 脚本加载成功日志
LogAdd(4, "[MapBuff] 地图BUFF脚本 [v3 - 效果系统] 已成功加载。")
