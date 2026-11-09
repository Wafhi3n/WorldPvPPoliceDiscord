-- WorldPvPPoliceDiscord_Locale_enUS.lua — overlay ANGLAIS (enUS/enGB). Clé FR → texte EN.
-- Chargé APRÈS WorldPvPPoliceDiscord_Locale.lua (qui crée NS.L). Sur un client non anglais : early-return.
local _, NS = ...
NS = NS or _G.WorldPvPPoliceDiscord
if not NS or not NS.L then return end

local locale = GetLocale and GetLocale() or "enUS"
if locale ~= "enUS" and locale ~= "enGB" then return end

local T = {
    -- Connexion
    ["version %s. Tape /%s pour l'aide."] = "version %s. Type /%s for help.",
    -- /wpp discord et /wpp fusion
    ["où en est le lien avec Discord"] = "where the link with Discord stands",
    ["guilde en chat fusionné : l'appel passe par le chat de guilde"] = "guild with merged chat: the call goes through guild chat",
    ["Discord : relié."] = "Discord: linked.",
    ["Discord : non relié. Le maître de guilde ou un officier relie la guilde et coche la case qui sépare le chat Discord (Guilde et communautés, clic droit sur la guilde). Guilde en chat fusionné : /wpp fusion on."] = "Discord: not linked. The guild leader or an officer links the guild and checks the box that separates Discord chat (Guild & Communities, right-click the guild). Guild with merged chat: /wpp fusion on.",
    ["Discord en chat fusionné : désactivé."] = "Discord with merged chat: off.",
    ["Discord en chat fusionné : activé, mais sans effet : la guilde a son fil Discord séparé."] = "Discord with merged chat: on, but it does nothing: the guild has its separate Discord chat.",
    ["Discord en chat fusionné : activé. Tes appels s'écrivent aussi dans le chat de guilde, les « J'arrive » suivent."] = "Discord with merged chat: on. Your calls are also written to guild chat, and “On my way” follows.",
    -- Encart sous la fenêtre de mort, compte rendu, « Ton appel »
    ["Discord : relié"] = "Discord: linked",
    ["Discord : non relié (appel en jeu seulement)"] = "Discord: not linked (in-game call only)",
    ["Discord : envoyé"] = "Discord: sent",
    ["Discord : envoi en cours"] = "Discord: sending",
    ["Discord : pas de retour"] = "Discord: no echo, not sent",
    ["Discord : dans %d s"] = "Discord: in %d s",
    ["Discord : non relié"] = "Discord: not linked",
    ["Discord : refusé"] = "Discord: refused",
    ["Discord : pas envoyé"] = "Discord: not sent",
    ["Discord : pas à jour"] = "Discord: not up to date",
    ["Discord : par le chat de guilde"] = "Discord: through guild chat",
    -- Infobulle : pourquoi l'appel ne va pas sur Discord
    ["L'appel part en jeu, pas sur Discord. Il faut :"] = "The call goes out in game, not to Discord. It takes:",
    ["- la guilde reliée à un serveur Discord ;"] = "- the guild linked to a Discord server;",
    ["- la case qui sépare le chat Discord du chat de guilde, cochée ;"] = "- the box that separates Discord chat from guild chat, checked;",
    ["- peut-être aussi ton compte Battle.net relié à Discord."] = "- maybe also your Battle.net account linked to Discord.",
    ["Le maître de guilde ou un officier s'en charge : Guilde et communautés (J), clic droit sur la guilde, ses réglages Discord."] = "The guild leader or an officer does this: Guild & Communities (J), right-click the guild, its Discord settings.",
    ["Guilde en chat fusionné : /wpp fusion on."] = "Guild with merged chat: /wpp fusion on.",
    ["Pas de bot World PvP Police sur le Discord de la guilde ? Désactive « World PvP Police Guild - Discord » dans la liste des AddOns : l'appel reste en jeu."] = "No World PvP Police bot on the guild's Discord? Turn off “World PvP Police Guild - Discord” in the AddOns list: the call stays in game.",
    -- Page d'options de World PvP Police Guild
    ["Discord en chat fusionné"] = "Discord with merged chat",
    ["Guilde reliée à Discord sans fil séparé : l'appel s'écrit aussi dans le chat de guilde, que toute la guilde voit. Comme /wpp fusion on | off."] = "Guild linked to Discord without a separate chat: the call is also written to guild chat, which the whole guild sees. Same as /wpp fusion on | off.",
}
for k, v in pairs(T) do NS.L[k] = v end
