-- WorldPvPPoliceDiscord_Locale_esES.lua — overlay ESPAGNOL (esES/esMX). Clé FR → texte ES.
-- Chargé APRÈS WorldPvPPoliceDiscord_Locale.lua (qui crée NS.L). Sur un client non espagnol : early-return.
local _, NS = ...
NS = NS or _G.WorldPvPPoliceDiscord
if not NS or not NS.L then return end

local locale = GetLocale and GetLocale() or "enUS"
if locale ~= "esES" and locale ~= "esMX" then return end

local T = {
    -- Connexion
    ["version %s. Tape /%s pour l'aide."] = "versión %s. Escribe /%s para ver la ayuda.",
    -- /wpp discord et /wpp fusion
    ["où en est le lien avec Discord"] = "cómo va el vínculo con Discord",
    ["guilde en chat fusionné : l'appel passe par le chat de guilde"] = "hermandad con chat combinado: la llamada pasa por el chat de hermandad",
    ["Discord : relié."] = "Discord: vinculado.",
    ["Discord : non relié. Le maître de guilde ou un officier relie la guilde et coche la case qui sépare le chat Discord (Guilde et communautés, clic droit sur la guilde). Guilde en chat fusionné : /wpp fusion on."] = "Discord: sin vincular. Quien lidera la hermandad o un oficial la vincula y marca la casilla que separa el chat de Discord (Hermandad y comunidades, clic derecho en la hermandad). Hermandad con chat combinado: /wpp fusion on.",
    ["Discord en chat fusionné : désactivé."] = "Discord con chat combinado: desactivado.",
    ["Discord en chat fusionné : activé, mais sans effet : la guilde a son fil Discord séparé."] = "Discord con chat combinado: activado, pero sin efecto: la hermandad tiene su chat de Discord separado.",
    ["Discord en chat fusionné : activé. Tes appels s'écrivent aussi dans le chat de guilde, les « J'arrive » suivent."] = "Discord con chat combinado: activado. Tus llamadas también se escriben en el chat de hermandad, y «Voy» las sigue.",
    -- Encart sous la fenêtre de mort, compte rendu, « Ton appel »
    ["Discord : relié"] = "Discord: vinculado",
    ["Discord : non relié (appel en jeu seulement)"] = "Discord: no vinculado (llamada solo en el juego)",
    ["Discord : envoyé"] = "Discord: enviado",
    ["Discord : envoi en cours"] = "Discord: enviando",
    ["Discord : pas de retour"] = "Discord: sin eco, no enviado",
    ["Discord : dans %d s"] = "Discord: en %d s",
    ["Discord : non relié"] = "Discord: no vinculado",
    ["Discord : refusé"] = "Discord: rechazado",
    ["Discord : pas envoyé"] = "Discord: no enviado",
    ["Discord : pas à jour"] = "Discord: sin actualizar",
    ["Discord : par le chat de guilde"] = "Discord: por el chat de hermandad",
    -- Infobulle : pourquoi l'appel ne va pas sur Discord
    ["L'appel part en jeu, pas sur Discord. Il faut :"] = "La llamada sale en el juego, no en Discord. Hace falta:",
    ["- la guilde reliée à un serveur Discord ;"] = "- la hermandad vinculada a un servidor de Discord;",
    ["- la case qui sépare le chat Discord du chat de guilde, cochée ;"] = "- la casilla que separa el chat de Discord del de hermandad, marcada;",
    ["- peut-être aussi ton compte Battle.net relié à Discord."] = "- quizá también tu cuenta de Battle.net vinculada a Discord.",
    ["Le maître de guilde ou un officier s'en charge : Guilde et communautés (J), clic droit sur la guilde, ses réglages Discord."] = "Se encarga quien lidera la hermandad o un oficial: Hermandad y comunidades (J), clic derecho en la hermandad, sus ajustes de Discord.",
    ["Guilde en chat fusionné : /wpp fusion on."] = "Hermandad con chat combinado: /wpp fusion on.",
    ["Pas de bot World PvP Police sur le Discord de la guilde ? Désactive « World PvP Police Guild - Discord » dans la liste des AddOns : l'appel reste en jeu."] = "¿No hay bot de World PvP Police en el Discord de la hermandad? Desactiva «World PvP Police Guild - Discord» en la lista de accesorios: la llamada se queda en el juego.",
    -- Page d'options de World PvP Police Guild
    ["Discord en chat fusionné"] = "Discord con chat combinado",
    ["Guilde reliée à Discord sans fil séparé : l'appel s'écrit aussi dans le chat de guilde, que toute la guilde voit. Comme /wpp fusion on | off."] = "Hermandad vinculada a Discord sin chat separado: la llamada también se escribe en el chat de hermandad, que ve toda la hermandad. Igual que /wpp fusion on | off.",
}
for k, v in pairs(T) do NS.L[k] = v end
