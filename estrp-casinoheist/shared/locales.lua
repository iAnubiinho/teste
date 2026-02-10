function Text(key, ...)
    local translation = Config.Locales[Config.Lang][key]
    if translation then
        return (translation):format(...)
    else
        return 'Not locale: ' .. key
    end
end

Config.title = "Casino Robbery"

Config.Locales = {
    ['EN'] = {
        nocops = "Not enough of cops",
        plantthermite = "Plant thermite",
        lockpicking = "Lockpicking door",
        lockpick = "Lockpick door",
        placedrill = "Place drill",
        hackpac = "Unlock door",
        hacking = "Unlocking door(s)",
        toopencell = "To open vault celldoor, use PC in the next room!",
        staircasedooropen = "Stairway door has been unlocked!",
        vaultcellopened = "Vault celldoor is opening!",
        doorunlocked = "Door(s) unlocked!",
        elevatoropened = "Elevator door has been unlocked!",
        useelevator = "[E] - Use Elevator",
        staircasetovault = "Door to staircase has been unlocked!",
        doortogarage = "Door to garage has been unlocked!",
        hackpanel = "Hack panel",
        drill = "Drill",
        opeshutters = "Open shutters",
        dooropen = "Door is unlocked, push it open!",
        vaultopen = "Vault door opens!",
        cutglass = "Cut glass",
        grab = "Grab",
        cuttingglass = "Cutting glass",
        plantc4 = "Plant C4",
        setoff = "[E] - Set off explosive(s)",
        casinorobbery = "Casino is being robbed!",
        doorlockmelted = "Door lock has been melted, door is open!",
        casinoleft = "Casino can be robbed again in: ",
        minutes = " minutes",
        lockpickfailed = "Lockpicking failed",
        nolockpick = "You do not have a lockpick!",
        nousb = "You do not have usb to hack pc with!",
        nocutter = "You do not have a plasmacutter!",
        nothermite = "You do not have thermite with you!",
        noknife = "You do not have a switchblade!",
        noc4 = "You do not have c4!",
        busy = "You are doing something!",
        cantdo = "You can not do this right now!",
        cantcarry = "You can not carry more!",
        open = "Open",
        takepainting = "Steal painting",
        openminisafe = "Crack minisafe",
        wiresbroken = "You ripped wires apart, garage door electric system is down, garage door is open!",
        failedbreak = "You failed to break the wires!",
        drillingvault = "Drilling vault door",
        nothermaldrill = "You do not have thermal drill!",
        nodrill = "You do not have a drill with you!",
        infoheader = "Casino PC",
        PC1 = 'This PC will unlock:  \n Elevator doors,  \n Garage slider-doors,  \n Garage main door,  \n Unlocking them will leave other doors open to guard,  \n Would you like to unlock them now?',
        PC2 = 'This PC will unlock:  \n Door to staircase, which leads to vault,  \n Door which leads to garage,  \n Would you like to unlock them now?',
        --- Discord webhook translations
        hasstarted = "Has started the Art Gallery robbery",
        safetydepositbox = "Got from safety deposit box: ",
        dirtymoney = "Stole dirty money in amount: ",
        cleanmoney = "Stole clean money in amount: ",
        markedmoney = "Stole marked money in amount: ",
        paintingtaken = "Stole painting: ",
        diamondtaken = "Stole: ",
        goldstack = "Stole gold from stack, in amount: ",
        goldtrolly = "Stole gold from trolly in amount: ",
        dirtymoneyminisafe = "Stole dirty money from safe, in amount: ",
        cleanmoneyminisafe = "Stole clean money from safe, in amount: ",
        Citizenid = "CitizenID: ",
        Name = "Name: ",
    },
}
