**Note: This AddOn only works on the original 2.4.3 client, it does *not* work on TBC Classic.**

# BigDebuffs

BigDebuffs is an _extremely lightweight_ addon which replaces unit frame portraits with auras, stances and interrupts whenever present.

The addon menu can be accessed by typing /bd or /bigdebuffs.

### Downloading

To download this addon, hit the **green "Code" button** and then select `Download ZIP`.

Once the addon is finished downloading, extract the contents to your `Interface/AddOns` directory and **importantly** rename the folder from `BigDebuffs-TBC-master` to `BigDebuffs`.

### Backport Notes
The backport is based on BfA BigDebuffs. However, the backport does not contain any raid frame modifications (number of debuffs shown / crowd control effects) since the new raid frames do not exist in WotLK (they were implemented in Cataclysm). The backport is essentially a much improved version of LoseControl.

The functionality of this AddOn is severely hampered in the TBC client and benefits greatly from using the **[BuffLib][1]** AddOn.

---
**Contributions**

 I'd like to thank the following people for their contributions to this release:
> [Jordon][2] for the base addon, as developed throughout MoP-BfA (and possibly further).

> [Jakeswork][3] for his work with the Warrior stance logic addition.

PS: If you'd like to improve the AddOn with more spells for TBC, please make a pull request or create an issue with the updated spells (according to the format in BigDebuffs.lua).


[1]: https://github.com/Schaka/BuffLib
[2]: https://github.com/jordonwow
[3]: https://github.com/jakeswork
