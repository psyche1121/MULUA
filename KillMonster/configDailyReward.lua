-- ================================================
-- 配置文件：configDailyReward.lua
-- 在这里定义每日登录奖励的内容
-- ================================================

ConfigDaily = {
    -- 奖励内容
    Rewards = {
        -- 1. 游戏币 (Zen)
        Money = 500000,

        -- 2. Ruud 点数
        Ruud = 0,  -- 如果不需要，可以设置为0

        -- 3. 商城点数 (需要 CashShopAddPoint 函数支持)
        WCoin = 0,         -- WCoin
        GoblinPoint = 0,   -- 哥布林点数
        
        -- 4. 奖励物品列表
        -- 每个物品都是一个独立的条目，可以添加多个
        Items = {
            -- 格式: { ItemID, Level, Dur, Skill, Luck, Option, Exc, Set }
            -- ItemID = 使用 GET_ITEM(大分类, 小分类) 获取

            -- 示例: 奖励 1x 祝福宝石
            { ItemID = GET_ITEM(14, 13), Level = 0, Dur = 0, Skill = 0, Luck = 0, Option = 0, Exc = 0, Set = 0 },

            -- 示例: 奖励 1x 灵魂宝石 (如果需要可以取消下面的注释)
            -- { ItemID = GET_ITEM(14, 14), Level = 0, Dur = 0, Skill = 0, Luck = 0, Option = 0, Exc = 0, Set = 0 },
        }
    },

    -- 发放奖励时向玩家显示的提示信息
    NoticeMessage = "恭喜您！获得今日的登录奖励，祝您游戏愉快！"
}

LogAdd(4, "[DailyReward] 每日奖励配置文件 (configDailyReward.lua) 已加载。")
