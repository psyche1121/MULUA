-- ============================
-- 配置文件：configkillmonster.lua
-- Rate=掉落权重，数值越大概率越高，按比例随机
-- ============================
Config = {
    MonsterLevelThreshold = 250, -- 怪物等级阈值（≥100才触发掉落）
    DropItems = {
        {ID = 0, Name = "波刃剑", Rate = 0},    -- 高概率
        {ID = 1, Name = "短剑", Rate = 0},      -- 中高概率
        {ID = 2, Name = "西洋剑", Rate = 0},    -- 中概率
        {ID = 3, Name = "东洋刀", Rate = 0},    -- 中低概率
        {ID = 4, Name = "暗杀者", Rate = 0},     -- 低概率
        {ID = 5, Name = "极光刀", Rate = 0},     -- 稀有
        {ID = 6, Name = "拉丁剑", Rate = 0},
        {ID = 7, Name = "偃月刀", Rate = 0},
        {ID = 8, Name = "巨蛇魔剑", Rate = 0},
        {ID = 9, Name = "背叛者", Rate = 0},
        {ID = 10, Name = "天行者", Rate = 8},
        {ID = 11, Name = "传说之剑", Rate = 5},
        {ID = 12, Name = "太阳之剑", Rate = 3},  -- 超稀有
        {ID = 13, Name = "真红之剑", Rate = 3},
        {ID = 14, Name = "雷神之剑", Rate = 2},
        {ID = 15, Name = "帝王之剑", Rate = 1},
        {ID = 4654, Name = "破坏之剑", Rate = 200}   -- 最稀有
    }
}
