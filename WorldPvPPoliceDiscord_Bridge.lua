-- WorldPvPPoliceDiscord_Bridge.lua — ce que le module fait de l'appel : la ligne du fil Discord, ou
-- celle du chat de guilde quand la guilde est en chat fusionné (spec
-- WorldPvPPolice/docs/specs/appel-a-l-aide.md D5, D12, D16 ; appel-sans-pont-discord.md S3, S5, S7).
--
-- Branché sur la prise de l'addon de base (WorldPvPPolice_Bridge.lua, NS:Plug) : la base prévient la
-- guilde, puis nous appelle DANS la pile du geste. Logique pure + des sondes (Bridge.probe) qui seules
-- touchent au jeu ; l'heure, le nom et le GUID sont ceux des sondes de la base (une seule horloge pour
-- l'appel).
--
-- DEUX RÈGLES DURES :
--   - C_Club.SendMessage exige un geste du joueur (clic, touche) : hors geste, c'est
--     ADDON_ACTION_BLOCKED, que pcall ne voit PAS. Sans geste (libération automatique, D13), rien ici.
--   - Une ligne Discord n'est PARTIE que quand elle revient en jeu (CHAT_MSG_GUILD_DISCORD, notre
--     texte, notre GUID ; mesuré sur Forever le 2026-10-10) dans les ECHO_WAIT secondes : un envoi
--     bloqué ne lève rien. D'ici là elle est « en cours » ; sans retour, rien n'est compté (ni délai
--     de 2 minutes, ni « déjà envoyée ») et le geste suivant la renvoie (décision du user, 2026-10-27).
local _, NS = ...
local WPP = _G.WorldPvPPolice
if not WPP then return end   -- la base absente, le jeu ne charge pas ce module (## Dependencies)
local Line = WPP.Line
local L = NS.L

local Bridge = {}
NS.Bridge = Bridge

Bridge.EVERY = 120      -- s entre deux lignes Discord d'un même appel (morts répétées, critère 4)
Bridge.ECHO_WAIT = 10   -- s laissées à la ligne pour revenir en jeu (délai jamais mesuré)

local function readable(v) return Line.Readable(v) end

local function returns(ok, ...)
    if not ok then return nil end
    return ...
end

local function call(fn, ...)
    if type(fn) ~= "function" then return nil end
    return returns(pcall(fn, ...))
end

local function text(v)
    if readable(v) and type(v) == "string" and v ~= "" then return v end
    return nil
end

local function now(p) return call(p.now) or 0 end

-- La ligne partie sans retour encore, { call, line, at } : en mémoire seulement, liée à CET appel (la
-- table de la base, la même tout le long de la session). Un /reload l'oublie (son attente du retour est
-- morte avec lui) et le geste suivant la renverra. Les autres champs (discordAt, discordSig, viaChat)
-- vivent sur l'appel de la base, gardé avec lui (D17).
Bridge.pending = nil

local function pendingOf(a)
    local pd = Bridge.pending
    if pd and a ~= nil and pd.call == a then return pd end
    return nil
end

-- Secondes avant que la ligne suivante de cet appel puisse partir (0 = dès le geste).
function Bridge:Wait(a)
    if not a.discordAt then return 0 end
    return math.max(0, math.ceil(Bridge.EVERY - (now(self.probe) - a.discordAt)))
end

-- La ligne de l'appel tel qu'il est (nil sans position) : « Ton appel » la compare à la dernière
-- revenue en jeu pour dire si Discord est à jour.
function Bridge:CurrentLine(a)
    local c = WPP.Call:Fields(a)
    return c and Line.BuildSOS(c) or nil
end

-- ===== L'appel qui part =====

-- Le champ F du SOS (S5) : l'option allumée et pas de fil séparé (avec le fil, elle n'a pas d'effet).
function Bridge:Fusion()
    if call(self.probe.fusion) ~= true then return nil end
    if call(self.probe.stream) then return nil end
    return true
end

-- O3 (S3, S5) : sans fil séparé et l'option allumée, la même ligne dans le chat de guilde, sur un geste,
-- même rythme, jamais en instance. Aucun retour à attendre : « chat » dit qu'elle est partie, pas qu'elle
-- a atteint Discord (une guilde pas reliée du tout ne fait que la voir passer).
function Bridge:ToGuildChat(a, c, gesture)
    if not a.fusion then return "none" end
    local p = self.probe
    local line = Line.BuildSOS(c)
    if not line then return "failed" end
    if a.discordSig == line then return "chatsame" end
    local inst = call(p.inInstance)
    if not gesture or (readable(inst) and inst == true) then return "nogesture" end
    local wait = self:Wait(a)
    if wait > 0 then return "later", wait end
    if not pcall(p.sendChat, line) then return "failed" end
    a.discordAt, a.discordSig, a.viaChat = now(p), line, true
    return "chat"
end

-- La ligne du fil : seulement sur un GESTE, au plus une toutes les EVERY secondes pour un même appel ;
-- une mise à jour retenue part avec le geste suivant (critère 4). « pending » = partie sans retour
-- encore : OnEcho la confirme, CheckEcho la déclare perdue.
function Bridge:ToDiscord(a, c, gesture)
    local p = self.probe
    local club, stream = call(p.stream)
    if not club then return self:ToGuildChat(a, c, gesture) end
    local line = Line.BuildSOS(c)
    if not line then return "failed" end
    if a.discordSig == line then return "same" end
    local pd = pendingOf(a)
    if pd then
        if now(p) - pd.at < Bridge.ECHO_WAIT then return "pending" end
        Bridge.pending = nil   -- jamais revenue (CheckEcho n'est pas encore passé) : comme refusée
    end
    if not gesture then return "nogesture" end
    local wait = self:Wait(a)
    if wait > 0 then return "later", wait end
    if not pcall(p.sendDiscord, club, stream, line) then return "failed" end
    Bridge.pending = { call = a, line = line, at = now(p) }
    call(p.after, Bridge.ECHO_WAIT + 1, function() Bridge:CheckEcho() end)
    return "pending"
end

-- La prise (Deliver) : (état, attente, parti ?). Parti = une ligne attend son retour, ou elle est
-- partie par le chat : l'appel s'ouvre même si la guilde n'a rien pris.
function Bridge:Deliver(a, c, gesture)
    local state, wait = self:ToDiscord(a, c, gesture)
    return state, wait, state == "pending" or state == "chat"
end

local function squash(s) return (s:gsub("%s+", " "):gsub("^ ", ""):gsub(" $", "")) end

-- La ligne est revenue en jeu (CHAT_MSG_GUILD_DISCORD : texte en 1er, GUID de l'auteur en 12e,
-- peut-être secrets) : elle est partie. Notre ligne et pas une autre : le même texte, blancs regroupés
-- (au cas où le serveur y toucherait) ; une ligne plus ancienne du même appel (même numéro, autre
-- message) ne confirme pas la nouvelle. Un GUID lisible qui n'est pas le nôtre = la ligne d'un autre.
-- Rend true si elle confirme l'envoi.
function Bridge:OnEcho(line, guid)
    local a = WPP.Call.active
    local pd = pendingOf(a)
    if not (pd and readable(line) and type(line) == "string") then return false end
    local mine = text((call(self.probe.guid)))
    if readable(guid) and type(guid) == "string" and guid ~= "" and guid ~= mine then return false end
    if line ~= pd.line and squash(line) ~= squash(pd.line) then return false end
    a.discordAt, a.discordSig, a.viaChat = pd.at, pd.line, nil
    Bridge.pending = nil
    WPP.Call:Notify("sent")
    return true
end

-- ECHO_WAIT secondes sans retour : la ligne n'est pas partie (bloquée, sans erreur). Rien n'est compté,
-- le geste suivant la renverra.
function Bridge:CheckEcho()
    local pd = pendingOf(WPP.Call.active)
    if not pd or now(self.probe) - pd.at < Bridge.ECHO_WAIT then return end
    Bridge.pending = nil
    WPP.Call:Notify("noecho")
end

-- ===== « C'est réglé », « J'arrive » (des gestes) =====

-- Une ligne de fin, par le fil s'il existe, sinon par le chat de guilde si `viaChat`.
function Bridge:Send(line, viaChat)
    local p = self.probe
    local club, stream = call(p.stream)
    if club then return pcall(p.sendDiscord, club, stream, line) and "sent" or "failed" end
    if viaChat then return pcall(p.sendChat, line) and "chat" or "failed" end
    return "none"
end

-- « END <moi> #SOS<n> » (D12) si une ligne de cet appel est partie ou en cours, par le fil, ou par le
-- chat de guilde si elle est passée par là (S5). Sans suivi de son retour : rien n'en dépend.
function Bridge:Settle(a)
    local had = a.discordSig or pendingOf(a)
    Bridge.pending = nil
    local line = had and Line.BuildEND(call(self.probe.me), a.n)
    if not line then return "none" end
    return self:Send(line, a.viaChat)
end

-- « OMW <moi> > <appelant> #SOS<n> » (D12), par le fil, ou par le chat de guilde si l'appel y passe (S5 :
-- l'appelant a l'option, il le dit dans son SOS, je n'ai rien à régler).
function Bridge:Respond(alert)
    local line = Line.BuildOMW(call(self.probe.me), alert.sender, alert.n)
    if not line then return "none" end
    return self:Send(line, alert.fusion)
end

-- ===== Ce que l'écran de la base montre de nous =====

function Bridge:PanelLine()
    if call(self.probe.stream) then return L["Discord : relié"] end
    if call(self.probe.fusion) == true then return L["Discord : par le chat de guilde"] end
    return L["Discord : non relié (appel en jeu seulement)"]
end

-- Lu au chargement : les traductions (overlays) sont déjà posées.
local REPORT = {
    chat = L["Discord : par le chat de guilde"], chatsame = L["Discord : par le chat de guilde"],
    pending = L["Discord : envoi en cours"], sent = L["Discord : envoyé"], same = L["Discord : envoyé"],
    noecho = L["Discord : pas de retour"], none = L["Discord : non relié"], nogesture = L["Discord : non relié"],
}

-- « … · Discord : envoyé » dans le compte rendu de l'encart.
function Bridge:ReportSuffix(r)
    if r.discord == nil then return nil end
    if r.discord == "later" then return string.format(L["Discord : dans %d s"], r.wait or 0) end
    return REPORT[r.discord] or L["Discord : refusé"]
end

-- « Morts : 2 · Discord : envoyé » dans « Ton appel ». « Envoyé » seulement si la dernière ligne
-- revenue en jeu (D16) est celle de l'appel tel qu'il est : une mort notée ou un message changé depuis,
-- et Discord n'est plus à jour. Le délai de 2 minutes se compte devant le joueur ; passé, il faut un
-- geste (« Mettre à jour »).
function Bridge:CallerSuffix(a)
    if pendingOf(a) then return L["Discord : envoi en cours"] end
    local line = self:CurrentLine(a)
    if a.discordSig and (not line or a.discordSig == line) then
        return a.viaChat and L["Discord : par le chat de guilde"] or L["Discord : envoyé"]
    end
    if not (a.fusion or call(self.probe.stream)) then return L["Discord : non relié"] end
    local wait = self:Wait(a)
    if wait > 0 then return string.format(L["Discord : dans %d s"], wait) end
    return a.discordSig and L["Discord : pas à jour"] or L["Discord : pas envoyé"]
end

function Bridge:Attach(parent, region)
    return NS.Stream.AttachWhy(parent, region)
end

-- ===== Sondes du jeu (remplacées par les tests) =====

Bridge.probe = {
    now         = function() return WPP.Call.probe.now() end,
    me          = function() return WPP.Call.probe.me() end,
    guid        = function() return WPP.Call.probe.guid() end,
    stream      = function() return NS.Stream.Get() end,
    fusion      = function() return NS.Stream.FusionOn() end,
    inInstance  = function() return (IsInInstance()) end,
    sendDiscord = function(club, stream, line) C_Club.SendMessage(club, stream, line) end,
    sendChat    = function(line) C_ChatInfo.SendChatMessage(line, "GUILD") end,
    after       = function(seconds, fn) C_Timer.After(seconds, fn) end,
}

-- Notre ligne revenue en jeu (texte en 1er, GUID en 12e) : inscrit sous pcall, un événement inconnu
-- d'un client lèverait.
local events = CreateFrame("Frame")
pcall(events.RegisterEvent, events, "CHAT_MSG_GUILD_DISCORD")
events:SetScript("OnEvent", function(_, _, ...) Bridge:OnEcho((...), (select(12, ...))) end)

WPP:Plug(Bridge)
