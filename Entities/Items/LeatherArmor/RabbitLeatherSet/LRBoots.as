void onInit(CBlob@ this)
{
    this.addCommandID("equip");
    this.addCommandID("unequip");

    this.Tag("armor");
    //move these vars to code bodies. My bad.
    this.set_f32("velocity", 0.05);
    this.set_f32("dodgechance", 2.0);
    this.set_f32("damagereduction", 0.05);
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
    if (this is null || caller is null) return;
    if (!this.isAttached()) return;
    if (caller.getName() != "archer" && caller.getName() != "rogue") return;

    if (!caller.get_bool("hasboots"))
    {
        CBitStream params;
	    params.write_u16(caller.getNetworkID());
	    caller.CreateGenericButton("$rl_boots$", Vec2f(0, 0), this, this.getCommandID("equip"), getTranslatedString("Equip"), params);
    }
    else
    {
        CBitStream params;
	    params.write_u16(caller.getNetworkID());
	    caller.CreateGenericButton("$rl_boots$", Vec2f(0, 0), this, this.getCommandID("unequip"), getTranslatedString("Unequip"), params);
    }
}

void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{
    if (cmd==this.getCommandID("equip"))
    {
        u16 callerid = params.read_u16();
        CBlob@ caller = getBlobByNetworkID(callerid);

        if (caller !is null)
        {
            if (caller.getCarriedBlob() !is null) caller.getCarriedBlob().server_Die();

            caller.set_bool("hasboots", true);
	        caller.set_string("bootsname", "rl_boots");

	        caller.set_f32("velocity", caller.get_f32("velocity") + 0.05);
            caller.set_f32("dodgechance", caller.get_f32("dodgechance") + 2.0);
            caller.set_f32("damagereduction", caller.get_f32("damagereduction") + 0.05);
        }
    }
    else if (cmd==this.getCommandID("unequip"))
    {
        u16 callerid = params.read_u16();
        CBlob@ caller = getBlobByNetworkID(callerid);

        if (caller !is null)
        {
            if (caller.get_bool("hasboots"))
            {
                if (isServer())
                {
                    server_CreateBlob(caller.get_string("bootsname"), caller.getTeamNum(), caller.getPosition());
                }
            }

            caller.set_bool("hasboots", false);
	        caller.set_string("bootsname", "");
            
	       	caller.set_f32("velocity", caller.get_f32("velocity") - 0.05);
            caller.set_f32("dodgechance", caller.get_f32("dodgechance") - 2.0);
            caller.set_f32("damagereduction", caller.get_f32("damagereduction") - 0.05);
        }
    }
}