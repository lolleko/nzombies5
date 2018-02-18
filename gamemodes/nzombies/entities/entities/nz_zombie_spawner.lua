AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName		= "nz_zombie_spawner"

ENT.Editable = true

function ENT:SetupDataTables()

	self:NetworkVar("String", 0, "Zone", {KeyName = "zone", Edit = {type = "Generic"}})
    self:NetworkVar("String", 1, "ZombieType", {KeyName = "zombieType", Edit = {type = "Generic"}})
    self:NetworkVar("Int", 2, "FirstRound", {KeyName = "firstRound", Edit = {type = "Int"}})
    self:NetworkVar("Int", 3, "RoundInterval", {KeyName = "roundInterval", Edit = {type = "Int"}})
    self:NetworkVar("Float", 4, "RequiredWeight", {KeyName = "requiredWeight", Edit = {type = "float"}})

    self:SetRequiredWeight(100)
end

function ENT:Initialize()
	self:SetModel( "models/player/odessa.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
	self:SetColor(Color(0, 255, 0))
	self:DrawShadow( false )

    if SERVER then
        self.nextSpawnThink = CurTime()
        self.weight = 0
        self.spawnThinkInterval = 3
    end
end

function ENT:IsSuitable()
	local tr = util.TraceHull( {
		start = self:GetPos(),
		endpos = self:GetPos(),
		filter = self,
		mins = Vector( -20, -20, 0 ),
		maxs = Vector( 20, 20, 70 ),
		ignoreworld = true,
		mask = MASK_NPCSOLID
	} )

	return not tr.Hit
end

function ENT:ChangeWeight(change)
    self.weight = math.max(0, self.weight + change)
end

function ENT:Think()
	if SERVER and self.nextSpawnThink < CurTime() then
        self.nextSpawnThink = CurTime() + self.spawnThinkInterval

        -- MAYBE? always add a bit of weight each time
        -- self.weight = self.weight + 10

        -- add/remove weight based on distance to players
        local averagePlayerPos = Vector(0, 0, 0)
        local players = player.GetAll()
        for _, ply in pairs(players) do
            averagePlayerPos = averagePlayerPos + ply:GetPos()
        end
        averagePlayerPos = averagePlayerPos / #players

        local spawners = {}
        for _, spawner in pairs(ents.FindByClass("nz_zombie_spawner")) do
            -- TODO only check for spawners that are already active (self:GetFirstRound() >= nz.CurrentRound())
            table.insert(spawners, {ent = spawner, dist = spawner:GetPos():DistToSqr(averagePlayerPos)})
        end
        table.sort(spawners, function (a, b)
            return a.dist < b.dist
        end)

        for i, spawner in ipairs(spawners) do
            spawner.ent:ChangeWeight(i - math.floor(#spawners / 2))
        end

        -- remove weight if spawn is blocked
        if not self:IsSuitable() then
            self:ChangeWeight(-10)
        end

        print(self.weight)

        if self.weight > self:GetRequiredWeight() then
            -- TODO spawn zombie
        end
	end
end

if CLIENT then
	function ENT:Draw()
		if nz.Mode.isCreate() then
			self:DrawModel()
		end
	end
end
