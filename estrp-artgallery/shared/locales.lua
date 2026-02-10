function Text(key, ...)
    local translation = Config.Locales[Config.Lang][key]
    if translation then
        return (translation):format(...)
    else
        return 'Not locale: ' .. key
    end
end

Config.title = "Art Gallery Robbery"

Config.Locales = {
    ['EN'] = {
        nocops = "Not enough of cops",
        plantthermite = "Plant thermite",
        lockpicking = "Lockpicking door",
        lockpick = "Lockpick door",
        hackpac = "Overload system",
        hacking = "Overloading System",
        hackpanel = "Hack panel",
        opeshutters = "Open shutters",
        dooropen = "Door is unlocked, push it open, to unlock slider toors break the wires in the fuse box!",
        cutglass = "Cut glass",
        cuttingglass = "Cutting glass",
        breakglass = "Break glass",
        galleryrobbery = "Art Gallery is being robbed!",
        doorlockmelted = "Door lock has been melted, door is open!",
        artrobberyleft = "Gallery can be robbed again in: ",
        minutes = " minutes",
        lockpickfailed = "Lockpicking failed",
        nolockpick = "You do not have a lockpick!",
        nousb = "You do not have usb to hack pc with!",
        nocutter = "You do not have a plasmacutter!",
        nothermite = "You do not have thermite with you!",
        noknife = "You do not have switchblade!", -- "WEAPON_SWITCHBLADE"
        nodrill = "You do not have laser drill!",
        busy = "You are doing something!",
        cantdo = "You can not do this right now!",
        cantcarry = "You can not carry more!",
        open = "Open",
        takepainting = "Steal painting",
        openshutters = "Open shutters",
        wiresbroken = "You ripped wires apart, slider door electric system is down, doors are open!",
        failedbreak = "You failed to break the wires!",
        novalidweapon = "You do not have strong enough weapon in hand to break the vitrine!",
        --- Discord webhook translations
        paintingtaken = "Stole painting: ",
        eggtaken = "Stole: ",
        brokevitrine = "Broke vitrine and stole: ",
        CitizenID = "CitizenID: ",
        Name = "Name: ",
    },
}
