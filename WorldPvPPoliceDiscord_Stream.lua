-- WorldPvPPoliceDiscord_Stream.lua — le fil « Discord » de la guilde (spec
-- WorldPvPPolice/docs/specs/appel-a-l-aide.md, D5 ; sorti de l'addon de base le 2026-11-09, S7).
--
-- Mesuré le 2026-10-10 (skill public wow-forever-api, chat-channels-and-communities.md) : un addon écrit
-- dans ce fil depuis un geste du joueur, et le fil n'existe qu'en flux SÉPARÉ ; en flux mêlé, rien ne
-- dit à un addon que la guilde est reliée (les getters de C_Discord sont protégés). Même lecture que
-- CraftingOrderClassic (Orders_AnnounceDiscord.lua, D.DiscordStream), mais chaque valeur est testée
-- AVANT d'être comparée : une valeur secrète lève même sur `== nil`.
local _, NS = ...
local WPP = _G.WorldPvPPolice
if not WPP then return end   -- la base absente, le jeu ne charge pas ce module (## Dependencies)

local Stream = {}
NS.Stream = Stream

local function readable(v) return WPP.Line.Readable(v) end

-- Une fonction du jeu, appelée sans jamais lever : ses retours, ou rien.
local function try(fn, ...)
    if type(fn) ~= "function" then return false end
    return pcall(fn, ...)
end

-- Le fil « Discord » de MA guilde : (clubId, streamId), ou nil — pas de guilde, flux mêlé, guilde pas
-- reliée, clubs pas encore prêts juste après la connexion. Relu à chaque appel : le chef peut délier
-- ou décocher pendant la session. Seulement des fonctions sans `HasRestrictions`.
function Stream.Get()
    local okG, inGuild = try(_G.IsInGuild)
    if not (okG and readable(inGuild) and inGuild) then return nil end
    local GI, Club = _G.C_GuildInfo, _G.C_Club
    local want = _G.Enum and _G.Enum.ClubStreamType and _G.Enum.ClubStreamType.Discord
    if not (want and GI and Club) then return nil end
    local okS, separate = try(GI.IsDiscordStreamSeparate)
    if not (okS and readable(separate) and separate == true) then return nil end
    local okC, clubId = try(Club.GetGuildClubId)
    if not (okC and readable(clubId)) then return nil end
    local okL, streams = try(Club.GetStreams, clubId)
    if not (okL and type(streams) == "table") then return nil end
    for _, s in ipairs(streams) do
        local ok, isDiscord, id = pcall(function() return s.streamType == want, s.streamId end)
        if ok and isDiscord == true and readable(id) then return clubId, id end
    end
    return nil
end

-- L'option « Discord en chat fusionné » (/wpp fusion, S3 de appel-sans-pont-discord.md) : sans fil
-- séparé, l'appel écrit aussi sa ligne dans le chat de guilde, que le pont mêlé porte sur Discord.
function Stream.FusionOn()
    return type(NS.db) == "table" and NS.db.fusion == true
end

-- Pourquoi l'appel ne va pas sur Discord, et qui peut y remédier (O1, S1) : l'addon ne sait pas quelle
-- condition manque (le flux mêlé ne se voit pas), il les énumère. La 3e n'a jamais été mesurée (M4).
function Stream.WhyLines()
    local L = NS.L
    return {
        L["L'appel part en jeu, pas sur Discord. Il faut :"],
        L["- la guilde reliée à un serveur Discord ;"],
        L["- la case qui sépare le chat Discord du chat de guilde, cochée ;"],
        L["- peut-être aussi ton compte Battle.net relié à Discord."],
        L["Le maître de guilde ou un officier s'en charge : Guilde et communautés (J), clic droit sur la guilde, ses réglages Discord."],
        L["Guilde en chat fusionné : /wpp fusion on."],
        L["Pas de bot World PvP Police sur le Discord de la guilde ? Désactive « World PvP Police Guild - Discord » dans la liste des AddOns : l'appel reste en jeu."],
    }
end

-- Au survol d'un texte de la base qui dit « Discord : … » (une chaîne de texte n'a pas de survol : un
-- cadre par-dessus, qui laisse passer les clics, donc le déplacement de la fenêtre). Rien tant que le fil
-- existe.
function Stream.AttachWhy(parent, region)
    local hover = CreateFrame("Frame", nil, parent)
    hover:SetAllPoints(region)
    hover:SetMouseMotionEnabled(true)
    hover:SetScript("OnEnter", function(self)
        if Stream.Get() then return end
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        for _, line in ipairs(Stream.WhyLines()) do GameTooltip:AddLine(line, 1, 1, 1, true) end
        GameTooltip:Show()
    end)
    hover:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return hover
end
