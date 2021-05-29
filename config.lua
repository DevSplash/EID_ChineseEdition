return {
  -- Change Width of the info boxes. (In characters)
  -- Default = 18
    ["TextboxWidth"]="18",
  -- Change Size of the info boxes. Range: [0,...,1]
  -- Default = 0.75
    ["Scale"]="0.75",
  -- Set transparency of the background. Range: [0,...,1]
  -- Default = 0.75
    ["Transparency"]="0.75",
    -- Set X Position (Width) of the descriptiontext
    -- Default = 70
    ["XPosition"]="70",
    -- Set Y Position (Height) of the descriptiontext
    -- Default = 30
    ["YPosition"]="30",
    -- Display informations when the floor has curse of the blind ( ? - Items)
    -- Default = false
    ["EnableOnCurse"]="false",
    -- Set the distance to an item in which informations will be displayed (in Tiles)
    -- Default = 4
    ["MaxDistance"]="4",
    -- Toggle Display of Transformation icons
    -- Default = true
    ["TransformationIcons"]="true",
    -- Toggle Display of Transformation text
    -- Default = true
    ["TransformationText"]="true",
    -- Toggle Display of Card / Rune descriptions
    -- Default = true
    ["DisplayCardInfo"]="true",
    -- Toggle Display of Card / Rune descriptions when its a shop item
    -- Default = false
    ["DisplayCardInfoShop"]="false",
    -- Error message displayed when an error occurs
    -- Default = [物品未找到]
    ["ErrorMessage"]="[物品未找到]",
    -- Toggle Display of Pill descriptions
    -- Default = true
    ["DisplayPillInfo"]="true",
    ["DisplayPillInfoShop"]="true",
    ["UnidentifiedPillMessage"]="— 未知胶囊",
    ["ShowUnidentifiedPillDescriptions"]= "false",
    -- 显示骰子房描述
    -- Default = true
    ["DisplayDiceRoomInfo"] = "true",
    -- 设置文字行高
    -- Default = 15
    ["FontLineHeigh"] = 15,
    -- 设置文字单行长度
    -- Default = 230
    ["FontMaxLength"] = 230,
    -- 设置字体大小，建议范围：10~25
    -- Default = 13
    ["FontSize"] = 13,
    -- 设置字体透明度，范围在0~1之间
    -- Default = 0.62
    ["FontTransparency"] = 0.62,
    -- 设置字体缩放
    -- Default = 1
    ["FontScale"] = 1,
    -- 设置字符表加载方式：0-仅动态加载，1-预先加载需要的字符表，2-预先加载完整字符表
    -- Default = 2
    ["FontLoadMode"] = 2
  }