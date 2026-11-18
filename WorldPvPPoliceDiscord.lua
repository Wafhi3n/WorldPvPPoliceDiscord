-- WorldPvPPoliceDiscord.lua — socle du module : table d'addon, réglages, SavedVariables, ses commandes
-- dans /wpp et sa case dans la page d'options de la base.
--
-- Le module Discord de World PvP Police Guild (spec WorldPvPPolice/docs/specs/appel-sans-pont-discord.md,
-- S7) : l'addon de base appelle à l'aide en jeu ; celui-ci écrit aussi les appels, les « J'arrive » et
-- les « C'est réglé » sur le Discord de la guilde, que lit le bot World PvP Police. Installé = allumé ;
-- pour couper, on le désactive dans la liste des AddOns. Il n'a pas de commande à lui : il ajoute
-- `/wpp discord` et `/wpp fusion` à celles de la base.
--
-- Chargé APRÈS la locale, AVANT _Stream.lua et _Bridge.lua (qui se branche sur la base).
local ADDON, NS = ...
local L = NS.L

NS.VERSION = "0.1.0-beta"   -- = ## Version du .toc ; scripts\bump_version.ps1 -Addon WorldPvPPoliceDiscord la tient égale
NS.TITLE = "World PvP Police Guild - Discord"   -- le nom du module, jamais traduit
_G.WorldPvPPoliceDiscord = NS

local WPP = _G.WorldPvPPolice
if not WPP then return end   -- la base absente, le jeu ne charge pas ce module (## Dependencies)

-- Réglages par défaut. CopyDefaults complète la base sans écraser ce que le joueur a changé ;
-- schemaVer sert le jour où une migration devient nécessaire. fusion : « Discord en chat fusionné »
-- (/wpp fusion on|off), pour tout le compte.
NS.DEFAULTS = {
    schemaVer = 1,
    fusion = false,
}

local function CopyDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            CopyDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

-- Jusqu'au 2026-11-09, le chat fusionné vivait dans la base (WorldPvPPoliceDB.fusion, jamais publié,
-- posé sur le PTR) : repris une fois, puis retiré de la base. Au PLAYER_LOGIN, quand les deux bases
-- sont lues à coup sûr.
function NS:Adopt(core)
    if self.db.fusion == nil and type(core) == "table" and type(core.fusion) == "boolean" then
        self.db.fusion = core.fusion
    end
    if type(core) == "table" then core.fusion = nil end
end

function NS:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ccff" .. NS.TITLE .. "|r " .. tostring(msg))
end

function NS:SetFusion(on)
    self.db.fusion = on and true or false
    if WPP.SettingsChanged then WPP:SettingsChanged() end   -- « Ton appel », l'encart, la page d'options
end

-- Une ligne par commande (skill chat-output), au nom de la base : le joueur a tapé /wpp.
function NS:PrintFusionState()
    if not NS.Stream.FusionOn() then
        WPP:Print(L["Discord en chat fusionné : désactivé."])
    elseif NS.Stream.Get() then
        WPP:Print(L["Discord en chat fusionné : activé, mais sans effet : la guilde a son fil Discord séparé."])
    else
        WPP:Print(L["Discord en chat fusionné : activé. Tes appels s'écrivent aussi dans le chat de guilde, les « J'arrive » suivent."])
    end
end

-- /wpp discord : où en est le lien, et qui peut y remédier (O1).
function NS:PrintDiscordState()
    if NS.Stream.Get() then
        WPP:Print(L["Discord : relié."])
    elseif NS.Stream.FusionOn() then
        self:PrintFusionState()
    else
        WPP:Print(L["Discord : non relié. Le maître de guilde ou un officier relie la guilde et coche la case qui sépare le chat Discord (Guilde et communautés, clic droit sur la guilde). Guilde en chat fusionné : /wpp fusion on."])
    end
end

if type(WPP.commands) == "table" and type(WPP.helpLines) == "table" then
    WPP.commands.discord = function() NS:PrintDiscordState() end
    WPP.commands.fusion = function(arg)
        if arg == "on" or arg == "off" then NS:SetFusion(arg == "on") end
        NS:PrintFusionState()
    end
    table.insert(WPP.helpLines, "/wpp discord - " .. L["où en est le lien avec Discord"])
    table.insert(WPP.helpLines, "/wpp fusion on | off - " .. L["guilde en chat fusionné : l'appel passe par le chat de guilde"])
end

-- Notre case dans la page de la base (construite à son premier affichage, après nous).
if WPP.OptionsPanel and type(WPP.OptionsPanel.LIST) == "table" then
    table.insert(WPP.OptionsPanel.LIST, {
        key = "fusion", label = L["Discord en chat fusionné"],
        tip = L["Guilde reliée à Discord sans fil séparé : l'appel s'écrit aussi dans le chat de guilde, que toute la guilde voit. Comme /wpp fusion on | off."],
        get = function() return type(NS.db) == "table" and NS.db.fusion == true end,
        set = function(on) NS:SetFusion(on) end,
    })
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON then
        WorldPvPPoliceDiscordDB = WorldPvPPoliceDiscordDB or {}
        NS.db = WorldPvPPoliceDiscordDB
    elseif event == "PLAYER_LOGIN" then
        NS:Adopt(WPP.db)
        CopyDefaults(NS.db, NS.DEFAULTS)
        -- Muet à la connexion, sauf la première après une installation ou une mise à jour (règle du
        -- user du 2026-10-11, skill publique `chat-output`). seenVersion vit dans la base du COMPTE.
        if NS.db.seenVersion ~= NS.VERSION then
            NS.db.seenVersion = NS.VERSION
            NS:Print(string.format(L["version %s. Tape /%s pour l'aide."], NS.VERSION, "wpp"))
        end
    end
end)
