#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>

new bool:g_bBlockDamage[33];

public plugin_init() {
	register_plugin("Dealing Damage Blocker", "1.0", "d0naciak.pl");

	register_clcmd("amx_blockdmg", "cmd_BlockDealingDamage", ADMIN_BAN, "<nick / sid / userid>");

	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage");
}

public client_connect(id) {
	g_bBlockDamage[id] = false;
}

public cmd_BlockDealingDamage(id, iLvl, iCmdId) {
	if(!cmd_access(id, iLvl, iCmdId, 2)) {
		return PLUGIN_CONTINUE;
	}

	new szArg[64], iTarget;
	read_argv(1, szArg, charsmax(szArg));
	
	if(!(iTarget = FindTarget(szArg))) {
		client_print(id, print_console, "*** Nie znaleziono gracza!");
		return PLUGIN_HANDLED;
	}

	if(get_user_flags(iTarget) & ADMIN_BAN) {
		client_print(id, print_console, "*** Gracz jest adminem!");
		return PLUGIN_HANDLED;
	}

	new szNick[64], szSID[64];

	g_bBlockDamage[iTarget] = true;

	get_user_name(iTarget, szNick, charsmax(szNick));
	get_user_authid(iTarget, szSID, charsmax(szSID));

	client_print(id, print_console, "Gracz %s (%s) pomyslnie dostal blokade zadawania obrazen", szNick, szSID);

	return PLUGIN_HANDLED;
}

public fw_TakeDamage(id, iEnt, iAtt, Float:fDmg, iDmgBits) {
	if(!is_user_connected(iAtt) || !g_bBlockDamage[iAtt]) {
		return HAM_IGNORED;
	}

	return HAM_SUPERCEDE;
}

FindTarget(szKey[]) {
	new iTarget;

	trim(szKey);
	remove_quotes(szKey);

	if(szKey[0] == '#' && (iTarget = find_player("kh", szKey[1]))) {
		return iTarget;
	}

	if((iTarget = find_player("bhl", szKey))) {
		return iTarget;
	}

	if((iTarget = find_player("ch", szKey))) {
		return iTarget;
	}

	return 0;
}
