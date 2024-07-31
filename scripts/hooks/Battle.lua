---@class Battle
---@field discoball DiscoBall
local Battle, super = Class("Battle", true)

function Battle:init()
	super.init(self)

	self.super_timer = 0

	self.superpower = false

    self.freeze_xp = 0

    self.killed = false

	self.selected_combo = nil

    -- Base pitch for the music to return to when not using timeslow.
    -- This must be changed along with music.pitch in order to correctly change the music's pitch.
    self.music.basepitch = self.music.pitch


    local month = tonumber(os.date("%m"))
    local day = tonumber(os.date("%d"))

    if month == 10 and day == 31 then
        local skeledance = Sprite("battle/skeledance/skeledance", SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        skeledance:setOrigin(0.5)
        skeledance:setColor(self.color)
	    skeledance:play(1/15, true)
	    skeledance:setScale(5, 2)
        skeledance.alpha = 7/255
        skeledance.debug_select = false
	    self:addChild(skeledance)

	    skeledance.layer = BATTLE_LAYERS["bottom"]
    end

    self.phasearmor = 0
    if BadgesLib:getBadgeEquipped("phasebadge") >= 1 then
        self.phasearmor = BadgesLib:getBadgeEquipped("phasebadge")
    end
	
	self.attack_left = false
end

-- FIXME: \/ copied from libraries/EnemyTension/scripts/hooks/Battle.lua

function Battle:postInit(state, encounter)
    super.postInit(self, state, encounter)

    -- If the enemy has a TP value defined, create a bar for it.
    if self.encounter.enemy_tension then
        self.enemy_tension_bar = EnemyTensionBar(639, 40, true)
        self:addChild(self.enemy_tension_bar)
    end
end

function Battle:updateIntro()
    self.intro_timer = self.intro_timer + 1 * DTMULT
    if self.intro_timer >= 15 then -- TODO: find out why this is 15 instead of 13
        for _,v in ipairs(self.party) do
            v:setAnimation("battle/idle")
        end
		if Mod.back_attack then
			self:setState("ENEMYDIALOGUE", "INTRO")
		else
			self:setState("ACTIONSELECT", "INTRO")
		end
    end
end

function Battle:showUI()
    super.showUI(self)
    if self.enemy_tension_bar then
        self.enemy_tension_bar:show()
    end
end

function Battle:onStateChange(old,new)
    super.onStateChange(self,old,new)

    if new == "INTRO" then

        for i,battler in ipairs(self.party) do
            if self.encounter.PINCER then
				if Mod.libs["moreparty"] then
					local classic = (Kristal.getLibConfig("moreparty", "classic_mode") and 3 or 4)
					if classic == 3 and #Game.party == 4 then classic = 2 end
					if #Game.party <= classic then
						if i%2 == 0 then
							battler.sprite.flip_x = true
							battler.left = true
						else
							battler.left = false
						end
					else
						if i > classic then
							battler.sprite.flip_x = true
							battler.left = true
						else
							battler.left = false
						end
					end
				else
					if i%2 == 0 then
						battler.sprite.flip_x = true
						battler.left = true
					else
						battler.left = false
					end
				end
			end
        end
    end

    if new == "VICTORY" then
        if self.enemy_tension_bar then
            self.enemy_tension_bar.animating_in = false
            self.enemy_tension_bar.shown = false
            self.enemy_tension_bar.physics.speed_x = 10
            self.enemy_tension_bar.physics.friction = -0.4
        end
        if Game.battle:getPartyBattler("YOU") then
            local guitarspin = Sprite("objects/guitarspin")
            local YOU = Game.battle:getPartyBattler("YOU")
            guitarspin:play(2/30, true)
            self:addChild(guitarspin)
            guitarspin.x = YOU.x
            guitarspin.y = YOU.y
            local oldlayer = guitarspin.layer
            guitarspin.layer = YOU.layer - 1
            guitarspin:setScale(2)
            guitarspin:setOrigin(0.5, 1)
            guitarspin.physics.direction = math.rad(270)
            guitarspin.physics.speed = 20
            local bonkrr = love.math.random(27, 30)
            if bonkrr <= 27 then
                Game.battle.timer:after(0.5, function ()
                    guitarspin.physics.gravity = 1
                    guitarspin.layer = oldlayer
                    Game.battle.timer:after((1 + 20/30), function ()
                        Assets.playSound("bonk")
                        guitarspin.physics.direction = 0
                        guitarspin.physics.gravity = 3
                        local YOU = Game.battle:getPartyBattler("YOU")
                        YOU:setAnimation("battle/victoryconcern")
                    end)
                end)
            end
        end
		for _,battler in ipairs(self.party) do
            battler:setSleeping(false)
            battler.defending = false
            battler.action = nil

            if battler.chara:getHealth() <= 0 then
                battler:revive()
                battler.chara:setHealth(battler.chara:autoHealAmount())
            end

            battler:setAnimation("battle/victory")

            local box = self.battle_ui.action_boxes[self:getPartyIndex(battler.chara.id)]
            box:resetHeadIcon()
        end

        self.money = self.money + (math.floor(((Game:getTension() * 2.5) / 10)) * Game.chapter)

        for _,battler in ipairs(self.party) do
            for _,equipment in ipairs(battler.chara:getEquipment()) do
                self.money = math.floor(equipment:applyMoneyBonus(self.money) or self.money)
				if equipment.id == "victory_bell" then
					battler:heal(20)
				end
            end
        end

        self.money = math.floor(self.money)

        self.money = self.encounter:getVictoryMoney(self.money) or self.money
        self.xp = self.encounter:getVictoryXP(self.xp) or self.xp
        -- if (in_dojo) then
        --     self.money = 0
        -- end

        Game.money = Game.money + self.money
        Game.xp = Game.xp + self.xp

        if (Game.money < 0) then
            Game.money = 0
        end

        local win_text = "* You won!\n* Got " .. self.xp .. " EXP and " .. self.money .. " "..Game:getConfig("darkCurrencyShort").."."
        -- if (in_dojo) then
        --     win_text == "* You won the battle!"
        -- end

        if self.xp > 0 or self.freeze_xp > 0 then
            local leveled_up, shown_xp_gain = false, self.xp

            if not Kristal.getLibConfig("leveling", "global_love") then
                shown_xp_gain = self.xp + self.freeze_xp

                local function addExpTo(battler, xp)
                    if battler.chara:addExp(xp) then
                        leveled_up = true
                    end
                end

                for _,battler in ipairs(self.party) do
                    local local_freezing = Kristal.getLibConfig("leveling", "local_freezing")
                    local grant_fxp = not local_freezing
                    if local_freezing then
                        for _,spell in ipairs(battler.chara:getSpells()) do
                            if spell:hasTag("ice") then
                                grant_fxp = true
                                break
                            end
                        end
                    end

                    addExpTo(battler, self.xp)
                    if grant_fxp then
                        addExpTo(battler, self.freeze_xp)
                    end
                end
            else
                leveled_up = Kristal.callEvent("addGlobalEXP", self.xp)
            end

            win_text = "* You won!\n* Got " .. shown_xp_gain .. " EXP and " .. self.money .. " "..Game:getConfig("darkCurrencyShort").."."
            if leveled_up then
                Assets.playSound("levelup")
                win_text = win_text.."\n* Your LOVE increased."
            end
        elseif self.used_violence and Game:getConfig("growStronger") then
            local stronger = "You"

            for _,battler in ipairs(self.party) do
                Game.level_up_count = Game.level_up_count + 1
                battler.chara:onLevelUp(Game.level_up_count)

                if battler.chara.id == Game:getConfig("growStrongerChara") then
                    stronger = battler.chara:getName()
                end
            end

            win_text = "* You won!\n* Got " .. self.money .. " "..Game:getConfig("darkCurrencyShort")..".\n* "..stronger.." became stronger."

            Assets.playSound("dtrans_lw", 0.7, 2)
            --scr_levelup()
        end

        win_text = self.encounter:getVictoryText(win_text, self.money, self.xp) or win_text

        if self.encounter.no_end_message then
            self:setState("TRANSITIONOUT")
            self.encounter:onBattleEnd()
        else
            self:battleText(win_text, function()
                self:setState("TRANSITIONOUT")
                self.encounter:onBattleEnd()
                return true
            end)
        end
    end
	
	if new == "ENEMYDIALOGUE" then
		local had_started = self.started
        if not self.started then
            self.started = true

            for _,battler in ipairs(self.party) do
                battler:resetSprite()
            end

            if self.encounter.music then
                self.music:play(self.encounter.music)
            end
        end

		if #Game.battle.enemies > 0 then
			self:showUI()
		end
	elseif new == "FLEE" then
        self.current_selecting = 0
		local flee_complete = false

        if self.tension_bar then
            self.tension_bar:hide()
        end

        for _,battler in ipairs(self.party) do
            battler:setSleeping(false)
            battler.defending = false
            battler.action = nil

            if battler.chara:getHealth() <= 0 then
                battler:revive()
                battler.chara:setHealth(1)
            end

			battler:setAnimation("battle/hurt")

            Assets.playSound("defeatrun")

			local sweat = Sprite("effects/defeat/sweat")
			sweat:setOrigin(0.5, 0.5)
			sweat:setScale(0.5, 0.5)
			sweat:play(5/30, true)
			sweat.layer = 100
			battler:addChild(sweat)

			Game.battle.timer:after(15/30, function()
				sweat:remove()
				battler:getActiveSprite().run_away_2 = true
				flee_complete = true
			end)

            local box = self.battle_ui.action_boxes[self:getPartyIndex(battler.chara.id)]
            box:resetHeadIcon()
        end
        
        -- self.money = self.money + (math.floor(((Game:getTension() * 2.5) / 10)) * Game.chapter)

        for _,battler in ipairs(self.party) do
            for _,equipment in ipairs(battler.chara:getEquipment()) do
                self.money = math.floor(equipment:applyMoneyBonus(self.money) or self.money)
            end
        end

        self.money = math.floor(self.money)

        self.money = self.encounter:getVictoryMoney(self.money) or self.money
        self.xp = self.encounter:getVictoryXP(self.xp) or self.xp
        -- if (in_dojo) then
        --     self.money = 0
        -- end

        Game.money = Game.money + self.money
        Game.xp = Game.xp + self.xp

        if (Game.money < 0) then
            Game.money = 0
        end
        
        local earn_text = ""
        if self.money ~= 0 or self.xp ~= 0 then
            earn_text = "* Ran away with " .. self.xp .. " EXP and " .. self.money .. " "..Game:getConfig("darkCurrencyShort").."."
        end
            
        if self.used_violence and Game:getConfig("growStronger") then
            local stronger = "You"

            for _,battler in ipairs(self.party) do
                Game.level_up_count = Game.level_up_count + 1
                battler.chara:onLevelUp(Game.level_up_count)

                if battler.chara.id == Game:getConfig("growStrongerChara") then
                    stronger = battler.chara:getName()
                end
            end

            earn_text = "* Ran away with " .. self.money .. " "..Game:getConfig("darkCurrencyShort")..".\n* "..stronger.." became stronger."

            Assets.playSound("dtrans_lw", 0.7, 2)
            --scr_levelup()
        end
        
        local flee_text = "* "
		
		local flee_list = {
			"I'm outta here.",
			"I've got better to do.",
			"Escaped...",
			"Don't slow me down."
		}
		
        for _,battler in pairs(Game.battle.party) do
            for _,text in pairs(battler.chara.flee_text) do
                table.insert(flee_list, text)
            end
        end
		
        if earn_text == "" then
            flee_text = flee_text .. Utils.pick(flee_list)
        else
            flee_text = earn_text
        end
		
        self:battleText(flee_text, function()
			for _,battler in ipairs(self.party) do
				battler:getActiveSprite().run_away_2 = false
				battler.x = battler.x - 240
			end
            self:setState("TRANSITIONOUT")
            self.encounter:onBattleEnd()
            return true
        end)
	end

    if old == "INTRO" then
        self.music.basepitch = self.music.pitch
    end
	
	if new == "ACTIONSELECT" then
		for _,battler in ipairs(self.enemies) do
			battler.wii_grab = false
		end
	end

    if self.discoball then
        -- For some reason this happens twice
        if new == "ACTIONSELECT" then
        self.discoball.tweendir = 1
        elseif new == "ENEMYDIALOGUE" or new == "DEFENDINGBEGIN" or new == "TRANSITIONOUT" then
        self.discoball.tweendir = -1
        end
    end

end

function Battle:hurt(amount, exact, target)
    -- Note: 0, 1 and 2 are to target a specific party member.
    -- In Kristal, we'll allow them to be objects as well.
    -- Also in Kristal, they're 1, 2 and 3.
    -- 3 is "ALL" in Kristal,
    -- while 4 is "ANY".
    target = target or "ANY"

    -- Alright, first let's try to adjust targets.

    if type(target) == "number" then
        target = self.party[target]
    end

    if isClass(target) and target:includes(PartyBattler) then
        if (not target) or (target.chara:getHealth() <= 0) then -- Why doesn't this look at :canTarget()? Weird.
            target = self:randomTargetOld()
        end
    end

    if target == "ANY" then
        target = self:randomTargetOld()

        -- Calculate the average HP of the party.
        -- This is "scr_party_hpaverage", which gets called multiple times in the original script.
        -- We'll only do it once here, just for the slight optimization. This won't affect accuracy.

        -- Speaking of accuracy, this function doesn't work at all!
        -- It contains a bug which causes it to always return 0, unless all party members are at full health.
        -- This is because of a random floor() call.
        -- I won't bother making the code accurate; all that matters is the output.

        local party_average_hp = 1

        for _,battler in ipairs(self.party) do
            if battler.chara:getHealth() ~= battler.chara:getStat("health") then
                party_average_hp = 0
                break
            end
        end

        -- Retarget... twice.
        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = self:randomTargetOld()
        end
        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = self:randomTargetOld()
        end

        -- If we landed on Kris (or, well, the first party member), and their health is low, retarget (plot armor lol)
        if (target == self.party[1]) and ((target.chara:getHealth() / target.chara:getStat("health")) < 0.35) then
            target = self:randomTargetOld()
        end

        -- They got hit, so un-darken them
        target.should_darken = false
        target.targeted = true
    end

    -- Now it's time to actually damage them!
    if isClass(target) and target:includes(PartyBattler) then
		if self.encounter.PINCER and self.attack_left ~= target.left then
			target:hurt(amount * Kristal.getLibConfig("pincer_battles", "opposite_mult") or 1.25, exact)
			if Kristal.getLibConfig("pincer_battles", "hit_face") then
				target.left = self.attack_left
				target.sprite.flip_x = target.left
			end
		else
			target:hurt(amount, exact)
		end
        return {target}
    end

    if target == "ALL" then
        Assets.playSound("hurt")
        for _,battler in ipairs(self.party) do
            if not battler.is_down then
				if self.encounter.PINCER and self.attack_left ~= battler.left then
					battler:hurt(amount * Kristal.getLibConfig("pincer_battles", "opposite_mult") or 1.25, exact, nil, {all = true})
					if Kristal.getLibConfig("pincer_battles", "hit_face") then
						battler.left = self.attack_left
						battler.sprite.flip_x = battler.left
					end
				else
					battler:hurt(amount, exact, nil, {all = true})
				end
            end
        end
        -- Return the battlers who aren't down, aka the ones we hit.
        return Utils.filter(self.party, function(item) return not item.is_down end)
    end
end

function Battle:swapSoul(object)

    Game.stage.timescale = 1
	Game.battle.music.pitch = Game.battle.music.basepitch
	Game.battle.soul.vhsfx.active = false
	Game.battle.soul.outlinefx.active = false
	Input.clear("a")
    
    
    super.swapSoul(self, object)
    
end

---Adds TP to the enemy's TP bar. Doesn't work if no enemy TP bar exists.
---@param tp integer Amount to give.
function Battle:giveEnemyTension(tp)
    self.encounter.enemy_tension = self.encounter.enemy_tension + tp
end

---Removes TP from the enemy's TP bar. Doesn't work if no enemy TP bar exists.
---@param tp integer Amount to remove.
function Battle:removeEnemyTension(tp)
    if self.encounter.enemy_tension - tp < 0 then
        self.encounter.enemy_tension = 0
    else
        self.encounter.enemy_tension = self.encounter.enemy_tension - tp
    end
end

---Returns current enemy TP value. Doesn't work if no enemy TP bar exists.
---@return integer tp
function Battle:getEnemyTension()
    return self.encounter.enemy_tension
end

---Sets enemy TP to the given value. Doesn't work if no enemy TP bar exists.
---@param tp integer Amount to set.
function Battle:setEnemyTension(tp)
    self.encounter.enemy_tension = tp
end

-- FIXME: /\ copied from libraries/EnemyTension/scripts/hooks/Battle.lua

function Battle:update()
	super.update(self)

	if self.superpower then
		if (self.super_timer - (DT * 30))%10 > self.super_timer%10 then
			Game:removeTension(1)

			if Game.tension <= 0 then
				self.superpower = false
				self.music:play(self.encounter.music)
			end
		end

		self.super_timer = self.super_timer + DT * 30
	end
end

function Battle:processAction(action)
    local battler = self.party[action.character_id]
    local party_member = battler.chara
    local enemy = action.target

    self.current_processing_action = action

    if enemy and enemy.done_state then
        enemy = self:retargetEnemy()
        action.target = enemy
        if not enemy then
            return true
        end
    end

    -- Call mod callbacks for onBattleAction to either add new behaviour for an action or override existing behaviour
    -- Note: non-immediate actions require explicit "return false"!
    local callback_result = Kristal.modCall("onBattleAction", action, action.action, battler, enemy)
    if callback_result ~= nil then
        return callback_result
    end
    for lib_id,_ in pairs(Mod.libs) do
        callback_result = Kristal.libCall(lib_id, "onBattleAction", action, action.action, battler, enemy)
        if callback_result ~= nil then
            return callback_result
        end
    end

    if action.action == "SPARE" then
        local worked = enemy:canSpare()

        battler:setAnimation("battle/spare", function()
            enemy:onMercy(battler)
            if not worked then
                enemy:mercyFlash()
            end
            self:finishAction(action)
        end)

        local text = enemy:getSpareText(battler, worked)
        if text then
            self:battleText(text)
        end

        return false

    elseif action.action == "ATTACK" or action.action == "AUTOATTACK" then
        local src = Assets.stopAndPlaySound(battler.chara:getAttackSound() or "laz_c")
        src:setPitch(battler.chara:getAttackPitch() or 1)

        self.actions_done_timer = 1.2

        local crit = action.points == 150 and action.action ~= "AUTOATTACK"
        if crit then
            Assets.stopAndPlaySound("criticalswing")

            for i = 1, 3 do
                local sx, sy = battler:getRelativePos(battler.width, 0)
                local sparkle = Sprite("effects/criticalswing/sparkle", sx + Utils.random(50), sy + 30 + Utils.random(30))
                sparkle:play(4/30, true)
                sparkle:setScale(2)
                sparkle.layer = BATTLE_LAYERS["above_battlers"]
                sparkle.physics.speed_x = Utils.random(2, 6) * (battler.left and -1 or 1)
                sparkle.physics.friction = -0.25
                sparkle:fadeOutSpeedAndRemove()
                self:addChild(sparkle)
            end
        end

        battler:setAnimation("battle/attack", function()
            action.icon = nil

            if action.target and action.target.done_state then
                enemy = self:retargetEnemy()
                action.target = enemy
                if not enemy then
                    self.cancel_attack = true
                    self:finishAction(action)
                    return
                end
            end

            local damage = Utils.round(enemy:getAttackDamage(action.damage or 0, battler, action.points or 0))
            if damage < 0 then
                damage = 0
            end

			if enemy.dt then
				local dmg_sprite = Sprite(battler.chara:getAttackSprite() or "effects/attack/cut")
				dmg_sprite:setOrigin(0.5, 0.5)
				if crit then
					dmg_sprite:setScale(2.5, 2.5)
				else
					dmg_sprite:setScale(2, 2)
				end
				dmg_sprite:setPosition(enemy:getRelativePos(enemy.width/2, enemy.height/2))
				dmg_sprite.layer = enemy.layer + 0.01
				dmg_sprite:play(1/15, false, function(s) s:remove() end)
				enemy.parent:addChild(dmg_sprite)

				local sound = enemy:getDamageSound() or "damage"
				if sound and type(sound) == "string" then
					Assets.stopAndPlaySound(sound)
				end
				
				enemy:hurt(damage, battler)
				
				local x, y = self:getRelativePos(enemy.x, enemy.y)
				local message = DTText(enemy.dt_text, -40, -20)
				enemy:addChild(message)
			elseif damage > 0 then
				Game:giveTension(Utils.round(enemy:getAttackTension(action.points or 100)))

				local dmg_sprite = Sprite(battler.chara:getAttackSprite() or "effects/attack/cut")
				dmg_sprite:setOrigin(0.5, 0.5)
				if crit then
					dmg_sprite:setScale(2.5, 2.5)
				else
					dmg_sprite:setScale(2, 2)
				end
				dmg_sprite:setPosition(enemy:getRelativePos(enemy.width/2, enemy.height/2))
				dmg_sprite.layer = enemy.layer + 0.01
				dmg_sprite:play(1/15, false, function(s) s:remove() end)
				enemy.parent:addChild(dmg_sprite)

				local sound = enemy:getDamageSound() or "damage"
				if sound and type(sound) == "string" then
					Assets.stopAndPlaySound(sound)
				end
				enemy:hurt(damage, battler)

				battler.chara:onAttackHit(enemy, damage)
			else
				enemy:statusMessage("msg", "miss", {battler.chara:getDamageColor()})
			end

			self:finishAction(action)

			Utils.removeFromTable(self.normal_attackers, battler)
			Utils.removeFromTable(self.auto_attackers, battler)

			if not self:retargetEnemy() then
				self.cancel_attack = true
			elseif #self.normal_attackers == 0 and #self.auto_attackers > 0 then
				local next_attacker = self.auto_attackers[1]

				local next_action = self:getActionBy(next_attacker)
				if next_action then
					self:beginAction(next_action)
					self:processAction(next_action)
				end
			end
        end)

        return false

    elseif action.action == "ACT" then
        -- fun fact: this would have only been a single function call
        -- if stupid multi-acts didn't exist

        -- Check for other short acts
        local self_short = false
        self.short_actions = {}
        for _,iaction in ipairs(self.current_actions) do
            if iaction.action == "ACT" then
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                if ienemy then
                    local act = ienemy and ienemy:getAct(iaction.name)

                    if (act and act.short) or (ienemy:getXAction(ibattler) == iaction.name and ienemy:isXActionShort(ibattler)) then
                        table.insert(self.short_actions, iaction)
                        if ibattler == battler then
                            self_short = true
                        end
                    end
                end
            end
        end

        if self_short and #self.short_actions > 1 then
            local short_text = {}
            for _,iaction in ipairs(self.short_actions) do
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                local act_text = ienemy:onShortAct(ibattler, iaction.name)
                if act_text then
                    table.insert(short_text, act_text)
                end
            end

            self:shortActText(short_text)
        else
            local text = enemy:onAct(battler, action.name)
            if text then
                self:setActText(text)
            end
        end

        return false

    elseif action.action == "SKIP" then
        return true

    elseif action.action == "SPELL" then
        self.battle_ui:clearEncounterText()

        -- The spell itself handles the animation and finishing
        action.data:onStart(battler, action.target)

        return false

    elseif action.action == "ITEM" then
        local item = action.data
        if item.refundable ~= false then
            if BadgesLib:getBadgeEquipped("refund") >= 1 then
                for i = 1, BadgesLib:getBadgeEquipped("refund") do -- Add money for each instance of the badge equipped
                    self.money = self.money + item.price / 4
                end
            end
        end
        if item.instant then
            -- RefundTxt is created in commitSingleAction for instant items.
            self:finishAction(action)
        else
            local text = item:getBattleText(battler, action.target)
            if text then
                self:battleText(text)
            end
            battler:setAnimation("battle/item", function()
                if item.refundable ~= false then
                    if BadgesLib:getBadgeEquipped("refund") >= 1 then
                        local refundTxt = RefundTxt()
                        battler:addChild(refundTxt)
                    end
                end
                local result = item:onBattleUse(battler, action.target)
                if result or result == nil then
                    self:finishAction(action)
                end
            end)
        end
        return false

    elseif action.action == "DEFEND" then
        battler:setAnimation("battle/defend")
        battler.defending = true
        return false

    else
        -- we don't know how to handle this...
        Kristal.Console:warn("Unhandled battle action: " .. tostring(action.action))
        return true
    end
end


function Battle:commitSingleAction(action)
    super.commitSingleAction(self, action)
    local battler = self.party[action.character_id]
	local target = action.target
	
	if self.encounter.PINCER and target and not target[1] then
		battler.old_left = battler.left
		battler.left = target.left
		battler.sprite.flip_x = battler.left
	end

    -- Spawns RefundTxt when using instant items.
    if (action.action == "ITEM" and action.data and (action.data.instant)) then
        if action.data.refundable ~= false then
            if BadgesLib:getBadgeEquipped("refund") >= 1 then
                local refundTxt = RefundTxt()
                battler:addChild(refundTxt)
            end
        end
    end
end

function Battle:removeSingleAction(action)
    local battler = self.party[action.character_id]
	
	if self.encounter.PINCER then
		battler.left = battler.old_left
		battler.sprite.flip_x = battler.left
	end

    if Kristal.callEvent("onBattleActionUndo", action, action.action, battler, action.target) then
        battler.action = nil
        self.character_actions[action.character_id] = nil
        return
    end

    battler:resetSprite()

    if action.tp then
        if action.tp < 0 then
            Game:giveTension(-action.tp)
        elseif action.tp > 0 then
            Game:removeTension(action.tp)
        end
    end

    if action.action == "ITEM" and action.data and action.item_index then
        if action.consumed then
            if action.result_item then
                Game.inventory:setItem(action.item_storage, action.item_index, action.data)
            else
                Game.inventory:addItemTo(action.item_storage, action.item_index, action.data)
            end
        end
        action.data:onBattleDeselect(battler, action.target)
    elseif action.action == "SPELL" and action.data then
        action.data:onDeselect(battler, action.target)
    end

    battler.action = nil
    self.character_actions[action.character_id] = nil
end

function Battle:pierce(amount, exact, target)
    target = target or "ANY"


    if type(target) == "number" then
        target = self.party[target]
    end

    if isClass(target) and target:includes(PartyBattler) then
        if (not target) or (target.chara:getHealth() <= 0) then -- Why doesn't this look at :canTarget()? Weird.
            target = self:randomTargetOld()
        end
    end

    if target == "ANY" then
        ---@type PartyBattler
        target = self:randomTargetOld()

        local party_average_hp = 1

        for _,battler in ipairs(self.party) do
            if battler.chara:getHealth() ~= battler.chara:getStat("health") then
                party_average_hp = 0
                break
            end
        end

        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = self:randomTargetOld()
        end

        -- They got hit, so un-darken them
        target.should_darken = false
        target.targeted = true
    end

    -- Now it's time to actually damage them!
    if isClass(target) and target:includes(PartyBattler) then
        target:pierce(amount, exact)
        return {target}
    end

    if target == "ALL" then
        Assets.playSound("hurt")
        for _,battler in ipairs(self.party) do
            if not battler.is_down then
                battler:pierce(amount, exact, nil, {all = true})
            end
        end
        -- Return the battlers who aren't down, aka the ones we hit.
        return Utils.filter(self.party, function(item) return not item.is_down end)
    end
end


function Battle:returnToWorld()
    if not Game:getFlag("tension_storage") then
        Game:setTension(0)
    end
    self.encounter:setFlag("done", true)
    if self.used_violence then
        self.encounter:setFlag("violenced", true)
    end
    self.transition_timer = 0
    for _,battler in ipairs(self.party) do
        if self.party_world_characters[battler.chara.id] then
            self.party_world_characters[battler.chara.id].visible = true
        end
    end
    local all_enemies = {}
    Utils.merge(all_enemies, self.defeated_enemies)
    Utils.merge(all_enemies, self.enemies)
    for _,enemy in ipairs(all_enemies) do
        local world_chara = self.enemy_world_characters[enemy]
        if world_chara then
            world_chara.visible = true
        end
        if not enemy.exit_on_defeat and world_chara and world_chara.parent then
            if world_chara.onReturnFromBattle then
                world_chara:onReturnFromBattle(self.encounter, enemy)
            end
        end
    end
    if self.encounter_context and self.encounter_context:includes(ChaserEnemy) then
        for _,enemy in ipairs(self.encounter_context:getGroupedEnemies(true)) do
            enemy:onEncounterEnd(enemy == self.encounter_context, self.encounter)
        end
    end
    self.music:stop()
    if self.resume_world_music then
        Game.world.music:resume()
    end
    self:remove()
    self.encounter.defeated_enemies = self.defeated_enemies
    Game.battle = nil
    Game.state = "OVERWORLD"
end

-- Failed attempt at recreating the CONCENTRATING thing, uncomment for a kinda cool effect
--[[
function Battle:drawBackground()
    Draw.setColor(0, 0, 0, self.transition_timer / 10)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)


    --for i = 2, 16 do
    --    Draw.setColor(66 / 255, 0, 66 / 255, (self.transition_timer / 10) / 2)
    --    love.graphics.line(0, -210 + (i * 50) + math.floor(self.offset / 2), 640, -210 + (i * 50) + math.floor(self.offset / 2))
    --    love.graphics.line(-200 + (i * 50) + math.floor(self.offset / 2), 0, -200 + (i * 50) + math.floor(self.offset / 2), 480)
    --end
    

    --
    for i = 3, 16 do
        Draw.setColor(66 / 255, 0, 66 / 255, self.transition_timer / 10)
        love.graphics.draw(Assets.getTexture("objects/concentrating"), 0, -100 + (i * 50) - math.floor(self.offset), 640, -100 + (i * 50) - math.floor(self.offset))
        love.graphics.line(-100 + (i * 50) - math.floor(self.offset), 0, -100 + (i * 50) - math.floor(self.offset), 480)
    end
end
--]]

function Battle:onKeyPressed(key)
    if Kristal.Config["debug"] and Input.ctrl() then
        if key == "h" then
            for _,party in ipairs(self.party) do
                party:heal(math.huge)
            end
        end
        if key == "y" then
			if self.state == "DEFENDING" and Game:isLight() then
				Game.battle:setState("DEFENDINGEND", "NONE")
			else
				Input.clear(nil, true)
				self:setState("VICTORY")
			end
        end
        if key == "m" then
            if self.music then
                if self.music:isPlaying() then
                    self.music:pause()
                else
                    self.music:resume()
                end
            end
        end
        if self.state == "DEFENDING" and key == "f" then
            self.encounter:onWavesDone()
        end
        if self.soul and key == "j" then
            self.soul:shatter(6)
            self:getPartyBattler(Game:getSoulPartyMember().id):hurt(math.huge)
        end
        if key == "b" then
            for _,battler in ipairs(self.party) do
                battler:hurt(math.huge)
            end
        end
        if key == "k" then
            Game:setTension(Game:getMaxTension() * 2, true)
        end
        if key == "n" then
            NOCLIP = not NOCLIP
        end
    end

    if self.state == "MENUSELECT" then
        local menu_width = 2
        local menu_height = math.ceil(#self.menu_items / 2)

        if Input.isConfirm(key) then
            local menu_item = self.menu_items[self:getItemIndex()]
            local can_select = self:canSelectMenuItem(menu_item)
            if self.encounter:onMenuSelect(self.state_reason, menu_item, can_select) then return end
            if Kristal.callEvent(KRISTAL_EVENT.onBattleMenuSelect, self.state_reason, menu_item, can_select) then return end
            if can_select then
                self.ui_select:stop()
                self.ui_select:play()
                menu_item["callback"](menu_item)
                return
            end
        elseif Input.isCancel(key) then
            if self.encounter:onMenuCancel(self.state_reason, menu_item) then return end
            if Kristal.callEvent(KRISTAL_EVENT.onBattleMenuCancel, self.state_reason, menu_item, can_select) then return end
            self.ui_move:stop()
            self.ui_move:play()
            Game:setTensionPreview(0)
            self:setState("ACTIONSELECT", "CANCEL")
            return
        elseif Input.is("left", key) then -- TODO: pagination
            self.current_menu_x = self.current_menu_x - 1
            if self.current_menu_x < 1 then
                self.current_menu_x = menu_width
                if not self:isValidMenuLocation() then
                    self.current_menu_x = 1
                end
            end
        elseif Input.is("right", key) then
            self.current_menu_x = self.current_menu_x + 1
            if not self:isValidMenuLocation() then
                self.current_menu_x = 1
            end
        end
        if Input.is("up", key) then
            self.current_menu_y = self.current_menu_y - 1
            if self.current_menu_y < 1 then
                self.current_menu_y = 1 -- No wrapping in this menu.
            end
        elseif Input.is("down", key) then
            if self:getItemIndex() % 6 == 0 and #self.menu_items % 6 == 1 and self.current_menu_y == menu_height - 1 then
                self.current_menu_x = self.current_menu_x - 1
            end
            self.current_menu_y = self.current_menu_y + 1
            if (self.current_menu_y > menu_height) or (not self:isValidMenuLocation()) then
                self.current_menu_y = menu_height -- No wrapping in this menu.
                if not self:isValidMenuLocation() then
                    self.current_menu_y = menu_height - 1
                end
            end
        end
    elseif self.state == "ENEMYSELECT" or self.state == "XACTENEMYSELECT" then
        if Input.isConfirm(key) then
            if self.encounter:onEnemySelect(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(KRISTAL_EVENT.onBattleEnemySelect, self.state_reason, self.current_menu_y) then return end
            self.ui_select:stop()
            self.ui_select:play()
            if #self.enemies_index == 0 then return end
            self.selected_enemy = self.current_menu_y
            if self.state == "XACTENEMYSELECT" then
                local xaction = Utils.copy(self.selected_xaction)
                if xaction.default then
                    xaction.name = self.enemies_index[self.selected_enemy]:getXAction(self.party[self.current_selecting])
                end
                self:pushAction("XACT", self.enemies_index[self.selected_enemy], xaction)
            elseif self.state_reason == "SPARE" then
                self:pushAction("SPARE", self.enemies_index[self.selected_enemy])
            elseif self.state_reason == "ACT" then
                self:clearMenuItems()
                local enemy = self.enemies_index[self.selected_enemy]
                for _,v in ipairs(enemy.acts) do
                    local insert = not v.hidden
                    if v.character and self.party[self.current_selecting].chara.id ~= v.character then
                        insert = false
                    end
                    if v.party and (#v.party > 0) then
                        for _,party_id in ipairs(v.party) do
                            if not self:getPartyIndex(party_id) then
                                insert = false
                                break
                            end
                        end
                    end
                    if insert then
                        self:addMenuItem({
                            ["name"] = v.name,
                            ["tp"] = v.tp or 0,
                            ["description"] = v.description,
                            ["party"] = v.party,
                            ["color"] = v.color or {1, 1, 1, 1},
                            ["highlight"] = v.highlight or enemy,
                            ["icons"] = v.icons,
                            ["callback"] = function(menu_item)
                                self:pushAction("ACT", enemy, menu_item)
                            end
                        })
                    end
                end
                self:setState("MENUSELECT", "ACT")
            elseif self.state_reason == "ATTACK" then
                self:pushAction("ATTACK", self.enemies_index[self.selected_enemy])
            elseif self.state_reason == "SPELL" then
                self:pushAction("SPELL", self.enemies_index[self.selected_enemy], self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", self.enemies_index[self.selected_enemy], self.selected_item)
            elseif self.state_reason == "COMBO" then
                self:pushAction("COMBO", self.enemies_index[self.selected_enemy], self.selected_combo)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            if self.encounter:onEnemyCancel(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(KRISTAL_EVENT.onBattleEnemyCancel, self.state_reason, self.current_menu_y) then return end
            self.ui_move:stop()
            self.ui_move:play()
            if self.state_reason == "SPELL" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            elseif self.state_reason == "COMBO" then
                self:setState("MENUSELECT", "COMBO")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            return
        end
        if Input.is("up", key) then
            if #self.enemies_index == 0 then return end
            local old_location = self.current_menu_y
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y - 1
                if self.current_menu_y < 1 then
                    self.current_menu_y = #self.enemies_index
                end
            until (self.enemies_index[self.current_menu_y] and self.enemies_index[self.current_menu_y].selectable)

            if self.current_menu_y ~= old_location then
                self.ui_move:stop()
                self.ui_move:play()
            end
        elseif Input.is("down", key) then
            if #self.enemies_index == 0 then return end
            local old_location = self.current_menu_y
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y + 1
                if self.current_menu_y > #self.enemies_index then
                    self.current_menu_y = 1
                end
            until (self.enemies_index[self.current_menu_y] and self.enemies_index[self.current_menu_y].selectable)

            if self.current_menu_y ~= old_location then
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
    elseif self.state == "PARTYSELECT" then
        if Input.isConfirm(key) then
            if self.encounter:onPartySelect(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(KRISTAL_EVENT.onBattlePartySelect, self.state_reason, self.current_menu_y) then return end
            self.ui_select:stop()
            self.ui_select:play()
            if self.state_reason == "SPELL" then
                self:pushAction("SPELL", self.party[self.current_menu_y], self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", self.party[self.current_menu_y], self.selected_item)
            elseif self.state_reason == "COMBO" then
                self:pushAction("COMBO", self.party[self.current_menu_y], self.selected_combo)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            if self.encounter:onPartyCancel(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(KRISTAL_EVENT.onBattlePartyCancel, self.state_reason, self.current_menu_y) then return end
            self.ui_move:stop()
            self.ui_move:play()
            if self.state_reason == "SPELL" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            return
        end
        if Input.is("up", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y - 1
            if self.current_menu_y < 1 then
                self.current_menu_y = #self.party
            end
        elseif Input.is("down", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y + 1
            if self.current_menu_y > #self.party then
                self.current_menu_y = 1
            end
        end
    elseif self.state == "BATTLETEXT" then
        -- Nothing here
    elseif self.state == "SHORTACTTEXT" then
        if Input.isConfirm(key) then
            if (not self.battle_ui.short_act_text_1:isTyping()) and
               (not self.battle_ui.short_act_text_2:isTyping()) and
               (not self.battle_ui.short_act_text_3:isTyping()) then
                self.battle_ui.short_act_text_1:setText("")
                self.battle_ui.short_act_text_2:setText("")
                self.battle_ui.short_act_text_3:setText("")
                for _,iaction in ipairs(self.short_actions) do
                    self:finishAction(iaction)
                end
                self.short_actions = {}
                self:setState("ACTIONS", "SHORTACTTEXT")
            end
        end
    elseif self.state == "ENEMYDIALOGUE" then
        -- Nothing here
    elseif self.state == "ACTIONSELECT" then
        self:handleActionSelectInput(key)
    elseif self.state == "ATTACKING" then
        self:handleAttackingInput(key)
    end
end

function Battle:processAction(action)
    local battler = self.party[action.character_id]
    local party_member = battler.chara
    local enemy = action.target

    self.current_processing_action = action

    local next_enemy = self:retargetEnemy()
    if not next_enemy then
        return true
    end

    if enemy and enemy.done_state then
        enemy = next_enemy
        action.target = next_enemy
    end

    -- Call mod callbacks for onBattleAction to either add new behaviour for an action or override existing behaviour
    -- Note: non-immediate actions require explicit "return false"!
    local callback_result = Kristal.modCall("onBattleAction", action, action.action, battler, enemy)
    if callback_result ~= nil then
        return callback_result
    end
    for lib_id,_ in Kristal.iterLibraries() do
        callback_result = Kristal.libCall(lib_id, "onBattleAction", action, action.action, battler, enemy)
        if callback_result ~= nil then
            return callback_result
        end
    end
	
	if action.action == "COMBO" then
        self.battle_ui:clearEncounterText()

        -- The combo itself handles the animation and finishing
        action.data:onStart(battler, action.target)

        return false
	end
	
	return super.processAction(self, action)
end

return Battle
