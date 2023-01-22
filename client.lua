--[ Object spawner by ArduousGamer/Dev ]
--[ Ped restriction by Xander1998 ]
--[ NativeUILua menu by Frazzle @ https://forum.fivem.net/t/release-dev-nativeuilua/98318 ]
--[ Coroner stretcher provided by majorpaine2015 @ http://www.lcpdfr.com/files/file/18046-body-bags/ ]


_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Object Spawner", "~b~Select Your Object")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

pedsList = {
	"s_m_y_cop_01",
	"s_f_y_cop_01",
	"s_m_y_hwaycop_01",
	"s_m_y_sheriff_01",
	"s_f_y_sheriff_01",
	"s_m_y_ranger_01",
	"s_f_y_ranger_01"
}

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddMenuOptionItem(Menu)
    local CD = UIMenuItem.New('Channelizer Drum', 'Spawn channelizer drum.')
    Menu:AddItem(CD)
    local CS = UIMenuItem.New('Coroner Stretcher', 'Spawn coroner stretcher.')
    Menu:AddItem(CS)
    local PB = UIMenuItem.New('Police Barrier', 'Spawn police barrier.')
    Menu:AddItem(PB)
    local RC = UIMenuItem.New('Traffic Cone', 'Spawn traffic cone.')
    Menu:AddItem(RC)
    local WB = UIMenuItem.New('Work Barrier', 'Spawn work barrier.')
    Menu:AddItem(WB)
    local WBA = UIMenuItem.New('Work Barrier (Arrow)', 'Spawn work barrier (Arrow).')
    Menu:AddItem(WBA)
    
    local RO = UIMenuItem.New('Remove Object', 'Remove object(s) (Stand Close).')
    Menu:AddItem(RO)

    local CM = UIMenuItem.New('Exit Menu', 'Close menu.')
    Menu:AddItem(CM)

    Menu.OnItemSelect = function(Sender, Item, Index)
        if Item == WB then
			SpawnObject('prop_mp_barrier_02b')
        elseif Item == PB then
            SpawnObject('prop_barrier_work05')
        elseif Item == WBA then
            SpawnObject('prop_mp_arrow_barrier_01')
        elseif Item == CD then
            SpawnObject('prop_barrier_wat_03a')
        elseif Item == RC then
            SpawnObject('prop_roadcone01a')
        elseif Item == CS then
            SpawnObject('prop_ld_binbag_01')

        elseif Item == RO then
            DeleteOBJ('prop_mp_barrier_02b')
            DeleteOBJ('prop_barrier_work05')
            DeleteOBJ('prop_mp_arrow_barrier_01')
            DeleteOBJ('prop_barrier_wat_03a')
            DeleteOBJ('prop_roadcone01a')
            DeleteOBJ('prop_ld_binbag_01')
        elseif Item == CM then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end

AddMenuOptionItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 51) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

function SpawnObject(objectname)
    local Player = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(Player, true))
    local heading = GetEntityHeading(Player)
   
    RequestModel(objectname)

    while not HasModelLoaded(objectname) do
	    Citizen.Wait(1)
    end

    if CheckPedRestriction(GetLocalPed(), pedsList) then
        local obj = CreateObject(GetHashKey(objectname), x, y, z-1.90, true, true, true)
	    PlaceObjectOnGroundProperly(obj)
        SetEntityHeading(obj, heading)
        FreezeEntityPosition(obj, true)
    else
       TriggerEvent("chatMessage", "", {255,255,255}, "^1You are not allowed to use this command.")
    end

end

function DeleteOBJ(theobject)
    local object = GetHashKey(theobject)
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, object, true) then
        local obj = GetClosestObjectOfType(x, y, z, 0.9, object, false, false, false)
        DeleteObject(obj)
    end
end

function CheckPedRestriction(ped, PedList)
	for i = 1, #PedList do
		if GetHashKey(PedList[i]) == GetEntityModel(ped) then
			return true
		end
	end
    return false
end

function GetLocalPed()
    return GetPlayerPed(PlayerId())
end
