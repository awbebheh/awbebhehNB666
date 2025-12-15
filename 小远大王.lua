-- 加载指定UI库（核心代码）【和有反应脚本一致】
local R = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
-- 玩家核心变量（确保功能正常运行）【只加1个必需依赖】
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService") -- 仅加这1个必需依赖
-- 主窗口（极简配置，适配手机端）【100%保留原代码】
local W = R:CreateWindow({
    Name = "小远专属免费",
    SizeX = 400,
    SizeY = 1000, -- 微调高度适配新增功能
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "小远工具盒",
        FileName = "配置保存"
    },
    KeySystem = false -- 关闭密钥验证，手机端直接注入
})
-- ===================================== 核心功能Tab（Tab1，新增游戏速度开关）=====================================
local Tab1 = W:CreateTab("1.功能", nil) -- 你的核心功能Tab
-- 【移动增强模块】（竖向排列第一组）
local MoveSection = Tab1:CreateSection("📱 移动增强")
-- 1. 开启移动增强总开关
local MovementToggle = Tab1:CreateToggle({
    Name = "开启移动增强",
    CurrentValue = false,
    Flag = "MovementToggle",
    Callback = function(Value)
        -- 关闭时恢复默认值
        if not Value then
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
            RootPart.CanCollide = true
        end
    end
})
-- 2. 步行速度调节（竖向紧跟）
Tab1:CreateSlider({
    Name = "步行速度",
    Range = {16, 500}, -- 缩小上限，避免手机端卡顿
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if R.Flags.MovementToggle then
            Humanoid.WalkSpeed = Value
        end
    end
})
-- 3. 跳跃力度调节（竖向紧跟）
Tab1:CreateSlider({
    Name = "跳跃力度",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if R.Flags.MovementToggle then
            Humanoid.JumpPower = Value
        end
    end
})
-- 4. 穿墙功能（竖向紧跟）
Tab1:CreateToggle({
    Name = "开启穿墙",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        if R.Flags.MovementToggle then
            RootPart.CanCollide = not Value
        end
    end
})
-- 【自动挂机模块】（竖向排列第二组）
local FarmSection = Tab1:CreateSection("💰 自动挂机")
-- 1. 开启自动挂机总开关
local AutoFarmToggle = Tab1:CreateToggle({
    Name = "开启自动挂机",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        while Value and task.wait(1) do
            if not R.Flags.AutoFarmToggle then break end
            -- 自动回血（血量低于50%时满血）
            if Humanoid.Health < Humanoid.MaxHealth * 0.5 then
                Humanoid.Health = Humanoid.MaxHealth
            end
            -- 自动捡硬币（按范围拾取）
            local PickRange = R.Flags.FarmRange or 10
            for _, Item in pairs(workspace:GetChildren()) do
                if Item:IsA("Part") and Item.Name:find("Coin") then
                    if (RootPart.Position - Item.Position).Magnitude < PickRange then
                        RootPart.CFrame = Item.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.2)
                    end
                end
            end
        end
    end
})
-- 2. 捡物范围调节（竖向紧跟）
Tab1:CreateSlider({
    Name = "捡物范围",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = 10,
    Flag = "FarmRange",
    Callback = function(Value)
        -- 范围值直接绑定到挂机功能，无需额外代码
    end
})
-- 【新增循环功能模块】（竖向排列第三组，Tab1内）
local NewLoopSection = Tab1:CreateSection("🔄 自动循环功能")
-- 1. 自动领取免费宝箱（循环）
local ClaimCrateToggle = Tab1:CreateToggle({
    Name = "自动领取免费宝箱",
    CurrentValue = false,
    Flag = "ClaimCrateToggle",
    Callback = function(Value)
        if _G.claimCrateConn then _G.claimCrateConn:Disconnect() end
        if Value then
            _G.claimCrateConn = RunService.RenderStepped:Connect(function()
                task.wait(2) -- 2秒循环一次
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("FreeCrateService"):WaitForChild("RF"):WaitForChild("ClaimFreeCrates"):InvokeServer()
                end)
            end)
        end
    end
})
-- 2. 自动购买挑战箱子150-8（循环）
local BuyShop8Toggle = Tab1:CreateToggle({
    Name = "自动购买挑战箱子150-8",
    CurrentValue = false,
    Flag = "BuyShop8Toggle",
    Callback = function(Value)
        if _G.buyShop8Conn then _G.buyShop8Conn:Disconnect() end
        if Value then
            _G.buyShop8Conn = RunService.RenderStepped:Connect(function()
                task.wait(3) -- 3秒循环一次
                local args = {"ChallengeShop", 8, 1}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("VendorService"):WaitForChild("RF"):WaitForChild("Purchase"):InvokeServer(unpack(args))
                end)
            end)
        end
    end
})
-- 3. 自动购买挑战箱子500-7（循环）
local BuyShop7Toggle = Tab1:CreateToggle({
    Name = "自动购买挑战箱子500-7",
    CurrentValue = false,
    Flag = "BuyShop7Toggle",
    Callback = function(Value)
        if _G.buyShop7Conn then _G.buyShop7Conn:Disconnect() end
        if Value then
            _G.buyShop7Conn = RunService.RenderStepped:Connect(function()
                task.wait(3) -- 3秒循环一次
                local args = {"ChallengeShop", 7, 1}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("VendorService"):WaitForChild("RF"):WaitForChild("Purchase"):InvokeServer(unpack(args))
                end)
            end)
        end
    end
})
-- 4. 自动购买宠物箱子-1（循环）
local BuyPetShopToggle = Tab1:CreateToggle({
    Name = "自动购买宠物箱子-1",
    CurrentValue = false,
    Flag = "BuyPetShopToggle",
    Callback = function(Value)
        if _G.buyPetShopConn then _G.buyPetShopConn:Disconnect() end
        if Value then
            _G.buyPetShopConn = RunService.RenderStepped:Connect(function()
                task.wait(3) -- 3秒循环一次
                local args = {"PetShop", 1, 1}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("VendorService"):WaitForChild("RF"):WaitForChild("Purchase"):InvokeServer(unpack(args))
                end)
            end)
        end
    end
})
-- 5. 自动购买材料1（循环）
local BuyMaterial1Toggle = Tab1:CreateToggle({
    Name = "自动购买材料1",
    CurrentValue = false,
    Flag = "BuyMaterial1Toggle",
    Callback = function(Value)
        if _G.buyMaterial1Conn then _G.buyMaterial1Conn:Disconnect() end
        if Value then
            _G.buyMaterial1Conn = RunService.RenderStepped:Connect(function()
                task.wait(2) -- 2秒循环一次
                local args = {1}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("MysteryMarketService"):WaitForChild("RE"):WaitForChild("TryBuyMaterial"):FireServer(unpack(args))
                end)
            end)
        end
    end
})
-- 6. 自动购买材料2（循环）
local BuyMaterial2Toggle = Tab1:CreateToggle({
    Name = "自动购买材料2",
    CurrentValue = false,
    Flag = "BuyMaterial2Toggle",
    Callback = function(Value)
        if _G.buyMaterial2Conn then _G.buyMaterial2Conn:Disconnect() end
        if Value then
            _G.buyMaterial2Conn = RunService.RenderStepped:Connect(function()
                task.wait(2) -- 2秒循环一次
                local args = {2}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("MysteryMarketService"):WaitForChild("RE"):WaitForChild("TryBuyMaterial"):FireServer(unpack(args))
                end)
            end)
        end
    end
})
-- 7. 自动召唤钻石1/50单位（循环）
local SummonStandardToggle = Tab1:CreateToggle({
    Name = "自动召唤钻石1/50单位",
    CurrentValue = false,
    Flag = "SummonStandardToggle",
    Callback = function(Value)
        if _G.summonStandardConn then _G.summonStandardConn:Disconnect() end
        if Value then
            _G.summonStandardConn = RunService.RenderStepped:Connect(function()
                task.wait(5) -- 5秒循环一次（避免频率过高）
                local args = {"Standard", 50}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UnitService"):WaitForChild("RF"):WaitForChild("SummonUnits"):InvokeServer(unpack(args))
                end)
            end)
        end
    end
})
-- 8. 自动召唤钻石二/50单位（循环）
local SummonBoostedToggle = Tab1:CreateToggle({
    Name = "自动召唤钻石二/50单位",
    CurrentValue = false,
    Flag = "SummonBoostedToggle",
    Callback = function(Value)
        if _G.summonBoostedConn then _G.summonBoostedConn:Disconnect() end
        if Value then
            _G.summonBoostedConn = RunService.RenderStepped:Connect(function()
                task.wait(5) -- 5秒循环一次
                local args = {"Boosted", 50}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UnitService"):WaitForChild("RF"):WaitForChild("SummonUnits"):InvokeServer(unpack(args))
                end)
            end)
        end
    end
})
-- 9. 自动召唤海螺/50单位（循环）
local SummonExclusiveToggle = Tab1:CreateToggle({
    Name = "自动召唤海螺/50单位",
    CurrentValue = false,
    Flag = "SummonExclusiveToggle",
    Callback = function(Value)
        if _G.summonExclusiveConn then _G.summonExclusiveConn:Disconnect() end
        if Value then
            _G.summonExclusiveConn = RunService.RenderStepped:Connect(function()
                task.wait(5) -- 5秒循环一次
                local args = {"Exclusive", 50}
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UnitService"):WaitForChild("RF"):WaitForChild("SummonUnits"):InvokeServer(unpack(args))
                end)
            end)
        end
    end
})
-- 10. 自动领取1-9号时长奖励（1个开关控制所有）
local ClaimPlaytimeToggle = Tab1:CreateToggle({
    Name = "自动领取1-9号时长奖励",
    CurrentValue = false,
    Flag = "ClaimPlaytimeToggle",
    Callback = function(Value)
        if _G.claimPlaytimeConn then _G.claimPlaytimeConn:Disconnect() end
        if Value then
            _G.claimPlaytimeConn = RunService.RenderStepped:Connect(function()
                task.wait(4) -- 4秒循环一次（避免请求过频）
                -- 循环领取1-9号奖励，一次全部触发
                for i = 1, 9 do
                    local args = {i}
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlaytimePrizeService"):WaitForChild("RF"):WaitForChild("ClaimPrize"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.3) -- 每个奖励间隔0.3秒，避免卡顿
                end
            end)
        end
    end
})

-- 【新增：小远大王（凋零风暴）生成模块】（竖向排列第四组，Tab1内）
local BossGenSection = Tab1:CreateSection("👑 小远大王（凋零风暴）")
-- 生成凋零风暴（小远大王）按钮
Tab1:CreateButton({
    Name = "生成小远大王（凋零风暴）",
    Callback = function()
        -- 先销毁已存在的凋零风暴，避免重复
        if game.Workspace:FindFirstChild("小远大王") then
            game.Workspace["小远大王"]:Destroy()
        end

        -- 初始化凋零风暴模型
        local object = game:GetObjects("rbxassetid://10973669978")[1]
        object.Name = "小远大王" -- 重命名为“小远大王”
        object.Parent = game.Workspace
        object:PivotTo(Player.Character:GetPivot())

        -- 创建名称标签（BillboardGui）
        local function createBossNameTag()
            local nameTag = Instance.new("BillboardGui")
            nameTag.Name = "BossNameTag"
            nameTag.Size = UDim2.new(0, 250, 0, 60)
            nameTag.AlwaysOnTop = true
            nameTag.MaxDistance = 600
            nameTag.StudsOffset = Vector3.new(0, 5, 0)
            nameTag.Parent = object

            local textLabel = Instance.new("TextLabel")
            textLabel.Text = "小远大王"
            textLabel.TextColor3 = Color3.new(1, 0.2, 0.2)
            textLabel.TextSize = 32
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.TextScaled = true
            textLabel.TextStrokeTransparency = 0.5
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Parent = nameTag
        end
        createBossNameTag()

        -- 阶段切换时重建名称标签
        local function recreateNameTag(newObject)
            if newObject:FindFirstChild("BossNameTag") then
                newObject.BossNameTag:Destroy()
            end
            local nameTag = Instance.new("BillboardGui")
            nameTag.Name = "BossNameTag"
            nameTag.Size = UDim2.new(0, 250, 0, 60)
            nameTag.AlwaysOnTop = true
            nameTag.MaxDistance = 600
            nameTag.StudsOffset = Vector3.new(0, 5, 0)
            nameTag.Parent = newObject

            local textLabel = Instance.new("TextLabel")
            textLabel.Text = "小远大王"
            textLabel.TextColor3 = Color3.new(1, 0.2, 0.2)
            textLabel.TextSize = 32
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.TextScaled = true
            textLabel.TextStrokeTransparency = 0.5
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Parent = nameTag
        end

        -- 凋零风暴核心逻辑（完整保留）
        local phaseModels = {
            [1] = "rbxassetid://10973669978",
            [2] = "rbxassetid://10980258642",
            [3] = "rbxassetid://10980269902",
            [4] = "rbxassetid://10394012803",
            [5] = "rbxassetid://16333160399",
            [6] = "rbxassetid://16333261175"
        }
        local phasePartsSucked = {0, 50, 100, 150, 200, 250}
        local currentPhase = 1
        local partsSucked = 0
        local attractedParts = {}

        local function isCharacterPart(part)
            local model = part:FindFirstAncestorWhichIsA("Model")
            return model and model:FindFirstChildWhichIsA("Humanoid") ~= nil
        end

        local function disableCollisions(model)
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        local function changePhase(newPhase)
            if currentPhase == newPhase then return end
            
            local oldPosition = object:GetPivot()
            object:Destroy()
            
            object = game:GetObjects(phaseModels[newPhase])[1]
            object.Name = "小远大王" -- 新阶段模型也重命名
            object.Parent = game.Workspace
            object:PivotTo(oldPosition)
            disableCollisions(object)
            currentPhase = newPhase
            recreateNameTag(object) -- 重建名称标签
            
            print("小远大王进化到阶段" .. newPhase)
        end

        local function onPartDestroyed()
            partsSucked = partsSucked + 1
            for i, threshold in ipairs(phasePartsSucked) do
                if partsSucked >= threshold and currentPhase < i then
                    changePhase(i)
                    break
                end
            end
        end

        -- 部件吸收协程
        coroutine.wrap(function()
            while true do
                task.wait(2)
                if not object then continue end
                local candidates = {}
                for _, obj in ipairs(game.Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Parent and not isCharacterPart(obj) and not obj:IsDescendantOf(object) and obj.Size.Magnitude < 20 and not table.find(attractedParts, obj) then
                        local dist = (obj.Position - object:GetPivot().Position).Magnitude
                        table.insert(candidates, {obj = obj, dist = dist})
                    end
                end
                if #candidates > 0 then
                    table.sort(candidates, function(a, b) return a.dist < b.dist end)
                    local chosen = candidates[1].obj
                    if chosen.Anchored then
                        chosen.Anchored = false
                    end
                    table.insert(attractedParts, chosen)
                end
            end
        end)()

        -- 移动+攻击逻辑
        RunService.Heartbeat:Connect(function(dt)
            for i = #attractedParts, 1, -1 do
                local obj = attractedParts[i]
                if obj and obj.Parent and not isCharacterPart(obj) then
                    local objectPos = object:GetPivot().Position
                    local dist = (obj.Position - objectPos).Magnitude
                    if dist > 2 then
                        local lerpAlpha = 0.2 * dt * (100 / dist)
                        local newPos = obj.Position:Lerp(objectPos, lerpAlpha)
                        obj.CFrame = CFrame.new(newPos) * obj.CFrame.Rotation
                    else
                        obj:Destroy()
                        table.remove(attractedParts, i)
                        onPartDestroyed()
                    end
                else
                    table.remove(attractedParts, i)
                end
            end
        end)

        local function getPhaseSettings()
            local phase = currentPhase
            if phase == 1 or phase == 2 or phase == 3 then
                return {
                    minHeight = 5,
                    maxHeight = 30,
                    speed = 1,
                    move = true
                }
            elseif phase == 4 then
                return {
                    minHeight = 15,
                    maxHeight = 25,
                    speed = 0.7,
                    move = true
                }
            elseif phase == 5 then
                return {
                    minHeight = 25,
                    maxHeight = 40,
                    speed = 0.3,
                    move = true
                }
            else
                return {
                    minHeight = 35,
                    maxHeight = 55,
                    speed = 0,
                    move = false
                }
            end
        end

        coroutine.wrap(function()
            while true do
                local settings = getPhaseSettings()
                if settings.move then
                    local startCFrame = object:GetPivot()
                    local playerPivot = Character:GetPivot()
                    local randomOffset = Vector3.new(math.random(-50, 50), math.random(settings.minHeight, settings.maxHeight), math.random(-50, 50))
                    local targetPos = playerPivot.Position + randomOffset
                    targetPos = Vector3.new(targetPos.X, math.max(targetPos.Y, playerPivot.Position.Y + settings.minHeight), targetPos.Z)
                    local dir = targetPos - startCFrame.Position
                    if dir.Magnitude < 1 then
                        task.wait(1)
                        continue
                    end
                    dir = dir.Unit
                    local targetCFrame = CFrame.lookAt(targetPos, targetPos + dir)
                    local duration = math.random(3/settings.speed, 10/settings.speed)
                    local elapsed = 0
                    while elapsed < duration do
                        elapsed += RunService.Heartbeat:Wait()
                        local alpha = elapsed / duration
                        object:PivotTo(startCFrame:Lerp(targetCFrame, alpha))
                    end
                else
                    local currentCFrame = object:GetPivot()
                    local currentPos = currentCFrame.Position
                    local playerPivot = Character:GetPivot()
                    local targetCFrame = CFrame.lookAt(currentPos, playerPivot.Position)
                    object:PivotTo(targetCFrame)
                    task.wait(0.1)
                end
            end
        end)()

        coroutine.wrap(function()
            while true do
                task.wait(3)
                if not Character or not Character:FindFirstChild("HumanoidRootPart") then continue end
                
                local skullTemplate = game:GetObjects("rbxassetid://16940644099")[1]
                local skull = skullTemplate:Clone()
                skull.Parent = game.Workspace
                
                local launchSound = Instance.new("Sound")
                launchSound.SoundId = "rbxassetid://127670808213759"
                launchSound.Volume = 2
                launchSound.Parent = game.Workspace
                launchSound:Play()
                
                local objectCFrame = object:GetPivot()
                local spawnOffset = objectCFrame.LookVector * 5
                skull:PivotTo(CFrame.new(objectCFrame.Position + spawnOffset) * objectCFrame.Rotation)
                
                local playerPos = Character.HumanoidRootPart.Position
                local skullDir = (playerPos - skull:GetPivot().Position).Unit
                local skullTargetCFrame = CFrame.lookAt(skull:GetPivot().Position, skull:GetPivot().Position + skullDir)
                skull:PivotTo(skullTargetCFrame)
                
                local speed = 50
                local moving = true
                coroutine.wrap(function()
                    while skull and skull.Parent and moving do
                        local dt = RunService.Heartbeat:Wait()
                        local newPos = skull:GetPivot().Position + skullDir * speed * dt
                        skull:PivotTo(CFrame.new(newPos) * skull:GetPivot().Rotation)
                    end
                end)()
                
                task.delay(17, function()
                    if skull and skull.Parent then
                        skull:Destroy()
                    end
                end)
                local touchedConnection
                local exploded = false
                touchedConnection = skull.DescendantAdded:Connect(function(desc)
                    if desc:IsA("BasePart") then
                        desc.Touched:Connect(function(other)
                            if not exploded and other and other.Parent then
                                exploded = true
                                moving = false
                                if touchedConnection then touchedConnection:Disconnect() end
                                
                                local explosionPos = skull:GetPivot().Position
                                local explosion = Instance.new("Explosion")
                                explosion.Position = explosionPos
                                explosion.BlastRadius = 10
                                explosion.BlastPressure = 0
                                explosion.Parent = game.Workspace
                                
                                local explodeSound = Instance.new("Sound")
                                explodeSound.SoundId = "rbxassetid://90854697257230"
                                explodeSound.Volume = 2
                                explodeSound.Parent = game.Workspace
                                explodeSound:Play()
                                
                                local playerRoot = Character:FindFirstChild("HumanoidRootPart")
                                if playerRoot then
                                    local dist = (playerRoot.Position - explosionPos).Magnitude
                                    if dist <= 10 then
                                        local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                                        if humanoid then
                                            humanoid:TakeDamage(45)
                                        end
                                    end
                                end
                                
                                skull:Destroy()
                            end
                        end)
                    end
                end)
                for _, desc in ipairs(skull:GetDescendants()) do
                    if desc:IsA("BasePart") then
                        desc.Touched:Connect(function(other)
                            if not exploded and other and other.Parent then
                                exploded = true
                                moving = false
                                if touchedConnection then touchedConnection:Disconnect() end
                                
                                local explosionPos = skull:GetPivot().Position
                                local explosion = Instance.new("Explosion")
                                explosion.Position = explosionPos
                                explosion.BlastRadius = 10
                                explosion.BlastPressure = 0
                                explosion.Parent = game.Workspace
                                
                                local explodeSound = Instance.new("Sound")
                                explodeSound.SoundId = "rbxassetid://90854697257230"
                                explodeSound.Volume = 2
                                explodeSound.Parent = game.Workspace
                                explodeSound:Play()
                                
                                local playerRoot = Character:FindFirstChild("HumanoidRootPart")
                                if playerRoot then
                                    local dist = (playerRoot.Position - explosionPos).Magnitude
                                    if dist <= 10 then
                                        local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                                        if humanoid then
                                            humanoid:TakeDamage(45)
                                        end
                                    end
                                end
                                
                                skull:Destroy()
                            end
                        end)
                    end
                end
            end
        end)()

        disableCollisions(object)
        local sound = Instance.new("Sound")
        sound.SoundId = getcustomasset("WHATHAVEYOUDONE.mp3")
        sound.Volume = 2
        sound.Parent = game.Workspace
        sound.Looped = true
        sound:Play()

        warn("✅ 小远大王（凋零风暴）已生成！仅你可见")
    end
})

-- 【新增：游戏速度调节模块】（竖向排列第五组，Tab1内）
local SpeedSection = Tab1:CreateSection("⚡ 游戏速度调节")
-- 1. 速度2倍
local Speed2xToggle = Tab1:CreateToggle({
    Name = "游戏速度2倍",
    CurrentValue = false,
    Flag = "Speed2xToggle",
    Callback = function(Value)
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("GameService"):WaitForChild("RF"):WaitForChild("ChangeGameSpeed"):InvokeServer(2)
            end)
        end
    end
})
-- 2. 速度3倍
local Speed3xToggle = Tab1:CreateToggle({
    Name = "游戏速度3倍",
    CurrentValue = false,
    Flag = "Speed3xToggle",
    Callback = function(Value)
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("GameService"):WaitForChild("RF"):WaitForChild("ChangeGameSpeed"):InvokeServer(3)
            end)
        end
    end
})
-- 3. 速度5倍
local Speed5xToggle = Tab1:CreateToggle({
    Name = "游戏速度5倍",
    CurrentValue = false,
    Flag = "Speed5xToggle",
    Callback = function(Value)
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("GameService"):WaitForChild("RF"):WaitForChild("ChangeGameSpeed"):InvokeServer(5)
            end)
        end
    end
})
-- 4. 速度7倍
local Speed7xToggle = Tab1:CreateToggle({
    Name = "游戏速度7倍",
    CurrentValue = false,
    Flag = "Speed7xToggle",
    Callback = function(Value)
        if Value then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("GameService"):WaitForChild("RF"):WaitForChild("ChangeGameSpeed"):InvokeServer(7)
            end)
        end
    end
})
-- 【战斗辅助模块】（竖向排列第六组）
local CombatSection = Tab1:CreateSection("⚔️ 战斗辅助")
-- 1. 开启自动攻击
Tab1:CreateToggle({
    Name = "开启自动攻击",
    CurrentValue = false,
    Flag = "AutoAttackToggle",
    Callback = function(Value)
        while Value and task.wait(0.5) do
            if not R.Flags.AutoAttackToggle then break end
            -- 自动锁定并攻击敌人（范围15）
            for _, Enemy in pairs(game.Players:GetPlayers()) do
                if Enemy ~= Player and Enemy.Character and Enemy.Character:FindFirstChild("HumanoidRootPart") then
                    local Distance = (RootPart.Position - Enemy.Character.HumanoidRootPart.Position).Magnitude
                    if Distance < 15 then
                        -- 这里可补充实际攻击代码（如点击、技能释放），暂留打印提示
                        print("自动攻击敌人：" .. Enemy.Name)
                    end
                end
            end
        end
    end
})
-- ===================================== 保留所有分类Tab（Tab4新增沙滩开关）=====================================
local T2 = W:CreateTab("2.空手道", nil) -- 空手道Tab（保留原有4个开关）
-- 1. 纯360°旋转
local RotateToggle = T2:CreateToggle({
    Name = "搭配第二个使用",
    CurrentValue = false,
    Flag = "RotateToggle",
    Callback = function(Value)
        if _G.rotateConn then _G.rotateConn:Disconnect() end
        if Value then
            _G.rotateConn = RunService.RenderStepped:Connect(function()
                local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0) end
            end)
        end
    end
})
-- 2. 纯原始攻击
local AttackToggle = T2:CreateToggle({
    Name = "开启自动攻击",
    CurrentValue = false,
    Flag = "AttackToggle",
    Callback = function(Value)
        if _G.attackConn then _G.attackConn:Disconnect() end
        if Value then
            _G.attackConn = RunService.RenderStepped:Connect(function()
                local char = Player.Character
                if char then char:FindFirstChild("KarateGloves").KarateGlove_Comm.RF.Attack:InvokeServer() end
            end)
        end
    end
})
-- 3. Mount循环系统（开启=持续召唤，关闭=取消）
local MountLoopToggle = T2:CreateToggle({
    Name = "开启Mount循环",
    CurrentValue = false,
    Flag = "MountLoopToggle",
    Callback = function(Value)
        if _G.mountLoopConn then _G.mountLoopConn:Disconnect() end
        if Value then
            _G.mountLoopConn = RunService.RenderStepped:Connect(function()
                task.wait(0.5)
                local args = {
                    "FamilyBoatmobile",
                    {toggle = true}
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("MountService"):WaitForChild("RF"):WaitForChild("Mount"):InvokeServer(unpack(args))
                end)
            end)
        else
            local args = {
                "FamilyBoatmobile",
                {toggle = false}
            }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("MountService"):WaitForChild("RF"):WaitForChild("Mount"):InvokeServer(unpack(args))
            end)
        end
    end
})
-- 4. Mount纯开关（无循环，只触发一次）
local MountToggle = T2:CreateToggle({
    Name = "Mount纯开关（单次）",
    CurrentValue = false,
    Flag = "MountToggle",
    Callback = function(Value)
        local args = {
            "FamilyBoatmobile",
            {toggle = Value}
        }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("MountService"):WaitForChild("RF"):WaitForChild("Mount"):InvokeServer(unpack(args))
        end)
    end
})
local T3 = W:CreateTab("3.突袭", nil)
-- Tab4（挑战）保留学校、章鱼、海盗船、雪地开关+新增沙滩开关
local T4 = W:CreateTab("4.挑战", nil)
local SchoolSection = T4:CreateSection("🏫 学校专属功能")
-- 1. 原有：学校开关（循环放塔）
local SchoolToggle = T4:CreateToggle({
    Name = "学校开关（循环放塔）",
    CurrentValue = false,
    Flag = "SchoolToggle",
    Callback = function(Value)
        if _G.schoolConn then _G.schoolConn:Disconnect() end
        if Value then
            local towerArgsList = {
                {CFrame.new(-35.407325744628906, 81.90117645263672, -47.23719024658203, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-20.603351593017578, 81.90117645263672, -36.73567581176758, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(10.251420021057129, 81.83256530761719, -45.46563720703125, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(0.7094478607177734, 81.83256530761719, -21.079193115234375, 1, 0, 0, 0, 1, 0, 0, 0, 1), 3},
                {CFrame.new(-19.668575286865234, 81.90118408203125, 27.525653839111328, 1, 0, 0, 0, 1, 0, 0, 0, 1), 5},
                {CFrame.new(-27.11876106262207, 81.90116882324219, -13.735664367675781, 1, 0, 0, 0, 1, 0, 0, 0, 1), 4},
                {CFrame.new(-39.36470413208008, 81.90116882324219, -13.653692245483398, 1, 0, 0, 0, 1, 0, 0, 0, 1), 6}
            }
            _G.schoolConn = RunService.RenderStepped:Connect(function()
                task.wait(6) -- 整体循环间隔6秒
                for _, args in ipairs(towerArgsList) do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("PlaceTower"):InvokeServer(unpack(args))
                    end)
                    task.wait(1) -- 间隔1秒
                end
            end)
        end
    end
})
-- 2. 原有：章鱼开关（循环放塔）
local OctopusToggle = T4:CreateToggle({
    Name = "章鱼开关（循环放塔）",
    CurrentValue = false,
    Flag = "OctopusToggle",
    Callback = function(Value)
        if _G.octopusConn then _G.octopusConn:Disconnect() end
        if Value then
            local octopusTowerArgs = {
                {CFrame.new(-71.17420959472656, 54.939144134521484, 54.54705047607422, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-63.30474853515625, 54.93914794921875, -53.963035583496094, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-30.50558090209961, 54.939151763916016, 18.034215927124023, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-34.849998474121094, 54.93914794921875, 29.438697814941406, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-46.17473602294922, 54.93914794921875, 25.45655059814453, 1, 0, 0, 0, 1, 0, 0, 0, 1), 3},
                {CFrame.new(-45.599342346191406, 54.939144134521484, -1.141286849975586, 1, 0, 0, 0, 1, 0, 0, 0, 1), 4},
                {CFrame.new(-64.2997817993164, 54.93914794921875, -9.964701652526855, 1, 0, 0, 0, 1, 0, 0, 0, 1), 5},
                {CFrame.new(-40.54979705810547, 54.93914794921875, -30.19508171081543, 1, 0, 0, 0, 1, 0, 0, 0, 1), 6}
            }
            _G.octopusConn = RunService.RenderStepped:Connect(function()
                task.wait(4) -- 整体循环间隔4秒
                for _, args in ipairs(octopusTowerArgs) do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("PlaceTower"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.5) -- 间隔0.5秒
                end
            end)
        end
    end
})
-- 3. 原有：海盗船开关（循环放塔）
local PirateShipToggle = T4:CreateToggle({
    Name = "海盗船开关（循环放塔）",
    CurrentValue = false,
    Flag = "PirateShipToggle",
    Callback = function(Value)
        if _G.pirateShipConn then _G.pirateShipConn:Disconnect() end
        if Value then
            local pirateTowerArgs = {
                {CFrame.new(-146.49935913085938, 9.147071838378906, 25.246427536010742, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-130.8951416015625, 9.147071838378906, 13.820867538452148, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-154.1397247314453, 9.147071838378906, 10.69876480102539, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-109.29359436035156, 9.147071838378906, -23.644987106323242, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-132.90328979492188, 9.147071838378906, -7.042604446411133, 1, 0, 0, 0, 1, 0, 0, 0, 1), 3},
                {CFrame.new(-144.1287841796875, 9.147071838378906, 2.784658432006836, 1, 0, 0, 0, 1, 0, 0, 0, 1), 4},
                {CFrame.new(-171.73880004882812, 9.147069931030273, -1.1253776550292969, 1, 0, 0, 0, 1, 0, 0, 0, 1), 5},
                {CFrame.new(-140.43496704101562, 9.147071838378906, -18.698041915893555, 1, 0, 0, 0, 1, 0, 0, 0, 1), 6}
            }
            _G.pirateShipConn = RunService.RenderStepped:Connect(function()
                task.wait(4) -- 整体循环间隔4秒
                for _, args in ipairs(pirateTowerArgs) do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("PlaceTower"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.5) -- 间隔0.5秒
                end
            end)
        end
    end
})
-- 4. 原有：雪地开关（循环放塔）
local SnowToggle = T4:CreateToggle({
    Name = "雪地开关（循环放塔）",
    CurrentValue = false,
    Flag = "SnowToggle",
    Callback = function(Value)
        if _G.snowConn then _G.snowConn:Disconnect() end
        if Value then
            local snowTowerArgs = {
                {CFrame.new(-61.76470947265625, 81.83255004882812, -39.36744689941406, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-47.0274543762207, 81.83255004882812, -30.971193313598633, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(9.464218139648438, 81.83255004882812, -1.715592384338379, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-33.34393310546875, 81.83255004882812, 27.272117614746094, 1, 0, 0, 0, 1, 0, 0, 0, 1), 3},
                {CFrame.new(-53.208580017089844, 81.83255004882812, 28.581371307373047, 1, 0, 0, 0, 1, 0, 0, 0, 1), 4},
                {CFrame.new(-40.969520568847656, 81.83255004882812, 16.135089874267578, 1, 0, 0, 0, 1, 0, 0, 0, 1), 5}
            }
            _G.snowConn = RunService.RenderStepped:Connect(function()
                task.wait(3) -- 整体循环间隔3秒
                for _, args in ipairs(snowTowerArgs) do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("PlaceTower"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.5) -- 间隔0.5秒
                end
            end)
        end
    end
})
-- 5. 新增：沙滩开关（循环放塔，间隔0.5秒）
local BeachToggle = T4:CreateToggle({
    Name = "沙滩开关（循环放塔）",
    CurrentValue = false,
    Flag = "BeachToggle",
    Callback = function(Value)
        if _G.beachConn then _G.beachConn:Disconnect() end
        if Value then
            -- 存储所有沙滩塔的放置参数（完整保留原坐标和ID）
            local beachTowerArgs = {
                {CFrame.new(-86.4440689086914, 56.06444549560547, -35.8013801574707, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-98.44832611083984, 56.0644416809082, -51.32762908935547, 1, 0, 0, 0, 1, 0, 0, 0, 1), 1},
                {CFrame.new(-67.84996795654297, 55.57595443725586, -1.304917335510254, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-8.330155372619629, 55.859474182128906, -18.21468162536621, 1, 0, 0, 0, 1, 0, 0, 0, 1), 2},
                {CFrame.new(-82.41590881347656, 56.06443786621094, -57.84386444091797, 1, 0, 0, 0, 1, 0, 0, 0, 1), 3},
                {CFrame.new(-40.97256851196289, 56.0644416809082, -78.99504089355469, 1, 0, 0, 0, 1, 0, 0, 0, 1), 5},
                {CFrame.new(-11.048604965209961, 56.0644416809082, 51.38597106933594, 1, 0, 0, 0, 1, 0, 0, 0, 1), 4},
                {CFrame.new(-55.209381103515625, 56.06444549560547, 8.7376127243042, 1, 0, 0, 0, 1, 0, 0, 0, 1), 6}
            }
            -- 循环放置，每个塔间隔0.5秒
            _G.beachConn = RunService.RenderStepped:Connect(function()
                task.wait(4) -- 整体循环间隔4秒（8个塔×0.5秒，避免拥挤）
                for _, args in ipairs(beachTowerArgs) do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TowerService"):WaitForChild("RF"):WaitForChild("PlaceTower"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.5) -- 间隔0.5秒，符合要求
                end
            end)
        end
    end
})
local T5 = W:CreateTab("5.角色", nil)
-- Tab6（竞技场）保留微速+超快开关
local T6 = W:CreateTab("6.竞技场", nil)
local VoteSection = T6:CreateSection("🗳️ 投票循环功能")
-- 【微速开关（0.5-1秒随机间隔）】
local SlowVoteToggle = T6:CreateToggle({
    Name = "微速开关（0.5-1秒）",
    CurrentValue = false,
    Flag = "SlowVoteToggle",
    Callback = function(Value)
        if _G.slowVoteConn then _G.slowVoteConn:Disconnect() end
        if Value then
            local MIN_SPEED = 0.5
            local MAX_SPEED = 1
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            
            -- 初始化投票接口
            local function InitSlowVote()
                local rfPath = pcall(function()
                    return ReplicatedStorage:WaitForChild("Packages", 5)
                        :WaitForChild("_Index", 5)
                        :WaitForChild("acecateer_knit@1.7.1", 5)
                        :WaitForChild("knit", 5)
                        :WaitForChild("Services", 5)
                        :WaitForChild("GameService", 5)
                        :WaitForChild("RF", 5)
                end)
                if not rfPath then warn("[微速开关] 未找到投票接口") return nil end
                local EndGameVote = rfPath:FindFirstChild("EndGameVote")
                local VoteStartRound = rfPath:FindFirstChild("VoteStartRound")
                return EndGameVote, VoteStartRound
            end
            
            local EndGameVote, VoteStartRound = InitSlowVote()
            if not (EndGameVote and VoteStartRound) then return end
            
            -- 微速循环逻辑
            _G.slowVoteConn = RunService.RenderStepped:Connect(function()
                pcall(function() EndGameVote:InvokeServer("Replay") end)
                pcall(function() VoteStartRound:InvokeServer() end)
                local randomWait = math.random(MIN_SPEED * 1000, MAX_SPEED * 1000) / 1000
                task.wait(randomWait)
            end)
        end
    end
})
-- 【超快开关（双模式独立控制）】
-- 模式1：双接口超快循环（0.005秒间隔）
local FastMode1Toggle = T6:CreateToggle({
    Name = "超快开关-双接口（0.005秒）",
    CurrentValue = false,
    Flag = "FastMode1Toggle",
    Callback = function(Value)
        if _G.fastMode1Conn then _G.fastMode1Conn:Disconnect() end
        local isRunning = Value
        local FAST_SPEED = 0.005
        local EndGameVote, VoteStartRound = nil, nil
        
        -- 初始化接口
        local function InitFastVote1()
            local rfPath = pcall(function()
                return game:GetService("ReplicatedStorage"):WaitForChild("Packages", 5)
                    :WaitForChild("_Index", 5)
                    :WaitForChild("acecateer_knit@1.7.1", 5)
                    :WaitForChild("knit", 5)
                    :WaitForChild("Services", 5)
                    :WaitForChild("GameService", 5)
                    :WaitForChild("RF", 5)
            end)
            if not rfPath then return end
            EndGameVote = rfPath:WaitForChild("EndGameVote", 5)
            VoteStartRound = rfPath:WaitForChild("VoteStartRound", 5)
        end
        InitFastVote1()
        
        if isRunning and EndGameVote and VoteStartRound then
            _G.fastMode1Conn = RunService.RenderStepped:Connect(function()
                if not R.Flags.FastMode1Toggle then return end
                pcall(function() EndGameVote:InvokeServer("Replay") end)
                pcall(function() VoteStartRound:InvokeServer() end)
                task.wait(FAST_SPEED)
            end)
        end
    end
})
-- 模式2：单接口超快循环（0.001秒间隔）
local FastMode2Toggle = T6:CreateToggle({
    Name = "超快开关-单接口（0.001秒）",
    CurrentValue = false,
    Flag = "FastMode2Toggle",
    Callback = function(Value)
        if _G.fastMode2Conn then _G.fastMode2Conn:Disconnect() end
        local isRunning = Value
        local singleLoopInterval = 0.001
        
        if isRunning then
            _G.fastMode2Conn = RunService.RenderStepped:Connect(function()
                if not R.Flags.FastMode2Toggle then return end
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("GameService"):WaitForChild("RF"):WaitForChild("VoteStartRound"):InvokeServer()
                end)
                task.wait(singleLoopInterval)
            end)
        end
    end
})
-- 加载UI（必须最后一行）
R:Load()
