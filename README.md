# World PvP Police Guild - Discord

Module de l'addon World PvP Police Guild (`WorldPvPPolice`), client visé : forever (et le PTR de
Retail tant que Forever sert peu). Il écrit les appels à l'aide, les « J'arrive » et les « C'est
réglé » sur le Discord de la guilde, où le bot World PvP Police (`WorldPvPPoliceBot`, à part) en fait
des cartes. Sans le bot sur son Discord, une guilde n'en a pas besoin : l'addon de base suffit.

Il n'a pas de commande à lui : il ajoute `/wpp discord` (où en est le lien) et `/wpp fusion on|off`
(guilde en chat fusionné) aux commandes de `/wpp`, et sa case à la page d'options de l'addon. Pour le
couper, on le désactive dans la liste des AddOns. Spec : `WorldPvPPolice/docs/specs/appel-sans-pont-discord.md`
(S7) et `appel-a-l-aide.md`.

Développé dans l'écosystème `F:\AddonDevellopement` : portes, déploiement et banc sont décrits dans
le `CLAUDE.md` de l'outillage. Registre de ce qui a été vu fonctionner en jeu :
`docs/verif-registre.md`.
