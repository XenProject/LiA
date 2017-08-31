modifier_fallen_champion_return = class({})

function modifier_fallen_champion_return:IsHidden()
	return true
end

function modifier_fallen_champion_return:IsPurgable()
	return false
end

function modifier_fallen_champion_return:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_fallen_champion_return:OnAttackLanded(params) 
	if params.target == self:GetParent() and not params.ranged_attack and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end


function modifier_fallen_champion_return:OnTakeDamage(params)
	--PrintTable("OnTakeDamage",params)
	if self:GetParent():PassivesDisabled() then
		return
	end

	if self.attack_record == params.record then

		if params.unit:HasModifier("modifier_brain_storm_decrepify") 
		or params.unit:HasModifier("modifier_hermit_decrepify") 
		or params.unit:HasModifier("modifier_illusionist_mastery_of_illusions") 
		or params.unit:HasModifier("modifier_decrepify_hero") then
			return
		end
		
		local return_damage 
		if RollPercentage(self:GetAbility():GetSpecialValueFor("full_damage_chance")) then
			return_damage = params.original_damage
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, params.attacker, return_damage, nil)
		else
			return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.original_damage
		end
		
		ApplyDamage(
		{
			victim = params.attacker, 
			attacker = params.unit, 
			damage = return_damage, 
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility()
		})
	end

end			