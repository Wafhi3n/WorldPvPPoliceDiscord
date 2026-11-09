-- WorldPvPPoliceDiscord_Locale_deDE.lua — overlay ALLEMAND. Clé FR → texte DE.
-- Chargé APRÈS WorldPvPPoliceDiscord_Locale.lua (qui crée NS.L). Sur un client non allemand : early-return.
local _, NS = ...
NS = NS or _G.WorldPvPPoliceDiscord
if not NS or not NS.L then return end

if (GetLocale and GetLocale() or "enUS") ~= "deDE" then return end

local T = {
    -- Connexion
    ["version %s. Tape /%s pour l'aide."] = "Version %s. Gib /%s für die Hilfe ein.",
    -- /wpp discord et /wpp fusion
    ["où en est le lien avec Discord"] = "wie es um die Verknüpfung mit Discord steht",
    ["guilde en chat fusionné : l'appel passe par le chat de guilde"] = "Gilde mit zusammengelegtem Chat: Der Ruf läuft über den Gildenchat",
    ["Discord : relié."] = "Discord: verknüpft.",
    ["Discord : non relié. Le maître de guilde ou un officier relie la guilde et coche la case qui sépare le chat Discord (Guilde et communautés, clic droit sur la guilde). Guilde en chat fusionné : /wpp fusion on."] = "Discord: nicht verknüpft. Die Gildenleitung oder ein Offizier verknüpft die Gilde und setzt das Häkchen, das den Discord-Chat trennt (Gilde & Communitys, Rechtsklick auf die Gilde). Gilde mit zusammengelegtem Chat: /wpp fusion on.",
    ["Discord en chat fusionné : désactivé."] = "Discord im zusammengelegten Chat: aus.",
    ["Discord en chat fusionné : activé, mais sans effet : la guilde a son fil Discord séparé."] = "Discord im zusammengelegten Chat: an, aber ohne Wirkung: Die Gilde hat ihren getrennten Discord-Chat.",
    ["Discord en chat fusionné : activé. Tes appels s'écrivent aussi dans le chat de guilde, les « J'arrive » suivent."] = "Discord im zusammengelegten Chat: an. Deine Rufe erscheinen auch im Gildenchat, „Ich komme“ folgt ihnen.",
    -- Encart sous la fenêtre de mort, compte rendu, « Ton appel »
    ["Discord : relié"] = "Discord: verbunden",
    ["Discord : non relié (appel en jeu seulement)"] = "Discord: nicht verbunden (Ruf nur im Spiel)",
    ["Discord : envoyé"] = "Discord: gesendet",
    ["Discord : envoi en cours"] = "Discord: wird gesendet",
    ["Discord : pas de retour"] = "Discord: kein Echo, nicht gesendet",
    ["Discord : dans %d s"] = "Discord: in %d s",
    ["Discord : non relié"] = "Discord: nicht verbunden",
    ["Discord : refusé"] = "Discord: abgelehnt",
    ["Discord : pas envoyé"] = "Discord: nicht gesendet",
    ["Discord : pas à jour"] = "Discord: nicht aktuell",
    ["Discord : par le chat de guilde"] = "Discord: über den Gildenchat",
    -- Infobulle : pourquoi l'appel ne va pas sur Discord
    ["L'appel part en jeu, pas sur Discord. Il faut :"] = "Der Ruf geht im Spiel raus, nicht zu Discord. Dafür braucht es:",
    ["- la guilde reliée à un serveur Discord ;"] = "- die Gilde mit einem Discord-Server verknüpft;",
    ["- la case qui sépare le chat Discord du chat de guilde, cochée ;"] = "- das Häkchen, das den Discord-Chat vom Gildenchat trennt;",
    ["- peut-être aussi ton compte Battle.net relié à Discord."] = "- vielleicht auch dein Battle.net-Konto mit Discord verknüpft.",
    ["Le maître de guilde ou un officier s'en charge : Guilde et communautés (J), clic droit sur la guilde, ses réglages Discord."] = "Das erledigt die Gildenleitung oder ein Offizier: Gilde & Communitys (J), Rechtsklick auf die Gilde, ihre Discord-Einstellungen.",
    ["Guilde en chat fusionné : /wpp fusion on."] = "Gilde mit zusammengelegtem Chat: /wpp fusion on.",
    ["Pas de bot World PvP Police sur le Discord de la guilde ? Désactive « World PvP Police Guild - Discord » dans la liste des AddOns : l'appel reste en jeu."] = "Kein World-PvP-Police-Bot auf dem Discord der Gilde? Schalte „World PvP Police Guild - Discord“ in der AddOn-Liste aus: Der Ruf bleibt im Spiel.",
    -- Page d'options de World PvP Police Guild
    ["Discord en chat fusionné"] = "Discord im zusammengelegten Chat",
    ["Guilde reliée à Discord sans fil séparé : l'appel s'écrit aussi dans le chat de guilde, que toute la guilde voit. Comme /wpp fusion on | off."] = "Gilde mit Discord verknüpft, ohne getrennten Chat: der Ruf erscheint auch im Gildenchat, den die ganze Gilde sieht. Wie /wpp fusion on | off.",
}
for k, v in pairs(T) do NS.L[k] = v end
