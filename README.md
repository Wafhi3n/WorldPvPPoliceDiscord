# World PvP Police Guild - Discord

An optional addon for [World PvP Police Guild](https://github.com/Wafhi3n/WorldPvPPolice), for WoW:
Forever. It writes the guild's calls for help, the "On my way" answers and the "All clear" to the
guild's Discord through the game's own Discord link, where the
[World PvP Police bot](https://github.com/Wafhi3n/WorldPvPPoliceBot) turns them into cards. A guild
without the bot doesn't need it.

It has no command of its own; it adds two to `/wpp`:

- `/wpp discord`: whether the guild is linked to Discord. It needs the guild linked to a Discord
  server with Discord chat separate from guild chat (guild leader or officer, Guild & Communities).
- `/wpp fusion on`, `/wpp fusion off`: for a guild on merged chat, also write the calls into guild
  chat, where the whole guild sees them. Off by default; also a box on the addon's settings page.

To turn it off, disable it in the AddOns list: calls then stay in game.

Languages: English, French, German, Spanish; other game languages fall back to English.

## How it works

`WorldPvPPoliceDiscord_Stream.lua` finds the guild's Discord stream (`C_Club`).
`WorldPvPPoliceDiscord_Bridge.lua` plugs into the base addon's hook (`WorldPvPPolice_Bridge.lua`)
and writes there with `C_Club.SendMessage`, on the player's own click, since the game refuses it
otherwise. A line only counts as sent once it comes back as `CHAT_MSG_GUILD_DISCORD`. The line format is shared with the bot and described in the base
addon's `WorldPvPPolice_Line.lua`.

Developed in a private workspace with its own checks and headless tests; what has been seen working
in game is logged in `docs/verif-registre.md`. MIT licensed.
