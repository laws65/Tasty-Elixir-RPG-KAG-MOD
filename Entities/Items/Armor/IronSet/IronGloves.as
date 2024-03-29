void onInit(CBlob@ this)
{
    this.addCommandID("equip");
    this.addCommandID("unequip");
    
    this.Tag("armor");

    this.set_f32("damagereduction", 0.1);
    this.set_f32("critchance", 5);
    this.set_f32("damagebuff", 0.15);
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
    if (this is null || caller is null) return;
    if (!this.isAttached()) return;
    if (caller.getName() != "knight") return;

    if (!caller.get_bool("hasgloves"))
    {
        CBitStream params;
	    params.write_u16(caller.getNetworkID());
	    caller.CreateGenericButton("$iron_gloves$", Vec2f(0, 0), this, this.getCommandID("equip"), getTranslatedString("Equip"), params);
    }
    else
    {
        CBitStream params;
	    params.write_u16(caller.getNetworkID());
	    caller.CreateGenericButton("$iron_gloves$", Vec2f(0, 0), this, this.getCommandID("unequip"), getTranslatedString("Unequip"), params);
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

            caller.set_bool("hasgloves", true);
	        caller.set_string("glovesname", "iron_gloves");

            caller.set_f32("damagereduction", caller.get_f32("damagereduction") + 0.1);
            caller.set_f32("critchance", caller.get_f32("critchance") + 5);
            caller.set_f32("damagebuff", caller.get_f32("damagebuff") + 0.15);
        }
    }
    else if (cmd==this.getCommandID("unequip"))
    {
        u16 callerid = params.read_u16();
        CBlob@ caller = getBlobByNetworkID(callerid);

        if (caller !is null)
        {
            if (caller.get_bool("hasgloves"))
            {
                if (isServer())
                {
                    server_CreateBlob(caller.get_string("glovesname"), caller.getTeamNum(), caller.getPosition());
                }
            }

            caller.set_bool("hasgloves", false);
	        caller.set_string("glovesname", "");

            caller.set_f32("damagereduction", caller.get_f32("damagereduction") - 0.1);
            caller.set_f32("critchance", caller.get_f32("critchance") - 5);
            caller.set_f32("damagebuff", caller.get_f32("damagebuff") - 0.15);
        }
    }
}