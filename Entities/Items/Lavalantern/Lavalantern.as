// Lantern script

#include "CustomBlocks.as";

void onInit(CBlob@ this)
{
	this.SetLight(true);
	this.SetLightRadius(86.0f);
	this.SetLightColor(SColor(255, 255, 240, 171));
	this.addCommandID("light on");
	this.addCommandID("light off");
	AddIconToken("$lantern on$", "Lantern.png", Vec2f(8, 8), 0);
	AddIconToken("$lantern off$", "Lantern.png", Vec2f(8, 8), 3);

	this.Tag("dont deactivate");
	this.Tag("fire source");
	this.Tag("ignore_arrow");
	this.Tag("ignore fall");
}

void onThisAddToInventory(CBlob@ this, CBlob@ inventoryBlob)
{
	Light(this, false);
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	Light(this, true);
}

void Light(CBlob@ this, bool on)
{
	if (!on)
	{
		this.SetLight(false);
		this.getSprite().SetAnimation("nofire");
	}
	else
	{
		this.SetLight(true);
		this.getSprite().SetAnimation("fire");
	}
	this.getSprite().PlaySound("SparkleShort.ogg");
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("activate"))
	{
		Light(this, !this.isLight());
	}

}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
    return blob.getShape().isStatic();
}
