
-- remove MedKit from Medic
table.Empty(RPExtraTeams[TEAM_MEDIC].weapons)

-- change medic description
RPExtraTeams[TEAM_MEDIC].description = [[With your medical knowledge you work to restore players to full health.
Without a medic, people cannot be healed.

People can press USE on you to request your services or with:
  /requestheal

You can offer your services to a player with:
  /offerheal

You have access to an array of medical supplies to buy.

You can heal yourself with:
  /buyhealth]]
