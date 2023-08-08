ESX = false
raison = ""
montant = ""
BillingList = {}
BillingListJob = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    playerLoaded = true
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RMenu.Add('Billing', 'mainBilling', RageUI.CreateMenu("Billing", "Billing"))
RMenu.Add('Billing', 'subBilling', RageUI.CreateSubMenu(RMenu:Get('Billing', 'mainBilling'), "Billing", "Billing"))
RMenu.Add('ListeFacture', 'subBilling2', RageUI.CreateSubMenu(RMenu:Get('Billing', 'mainBilling'), "Billing", "Billing"))
Citizen.CreateThread(function()

    while true do
        RageUI.IsVisible(RMenu:Get('Billing', 'mainBilling'), function()
        
            RageUI.Separator("↓ ~b~ Billing ~s~↓")
            RageUI.Line()
            if ESX.PlayerData.job.name ~= "unemployed" then
                RageUI.Button('Faire une facture', nil, { RightLabel = "→→→" }, true, {
                    onSelected = function()
                    end
                }, RMenu:Get('Billing', 'subBilling'))
            end


            RageUI.Button('Liste des facture', nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    GetBilling()
                    GetBillingJob()
                end
            }, RMenu:Get('ListeFacture', 'subBilling2'))

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('Billing', 'subBilling'), function()
            RageUI.Separator("↓ ~b~ Faire une facture ~s~↓")
            RageUI.Line()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                RageUI.Separator("~r~Aucun joueur à proximité")
            else
                Coord = GetEntityCoords(GetPlayerPed(closestPlayer))
                DrawMarker(0, Coord.x, Coord.y, Coord.z + 1.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 0, 0, 50, true, true, 2, nil, nil, false)

                RageUI.Button("Raison de la facture", nil, {RightLabel = ""}, true, {
                    onSelected = function()
                        raison = KeyboardInput("Raison de la facture", "", 100)
                        if raison == "" or raison == nil then
                            ESX.ShowNotification("Vous devez mettre une raison")
                            return 
                        end
                    end
                })
    
                RageUI.Button("Montant de la facture", nil, {RightLabel = ""}, true, {
                    onSelected = function()
                        montant = KeyboardInput("Montant de la facture", "", 100)
                        if tonumber(montant) == nil then
                            ESX.ShowNotification("Vous devez mettre un nombre")
                            montant = ""
                            return 
                        end
                        if tonumber(montant) < 0 then
                            ESX.ShowNotification("Vous devez mettre un nombre supérieur à 0")
                            return 
                        end

                    end
                })

                RageUI.Button("Envoyer la facture", nil, {RightLabel = "→→→"}, raison ~= "" and montant ~= "", {
                    onSelected = function()

                        ESX.ShowNotification("Vous avez envoyer une facture de ~g~"..montant.." $ ~s~à ~g~"..GetPlayerName(closestPlayer).."")
                        TriggerServerEvent('billing', GetPlayerServerId(closestPlayer) , raison, tonumber(montant), ESX.PlayerData.job.label)
                    end
                })
                if raison ~= "" or montant ~= "" then
                    RageUI.Line()
                end
                if raison ~= "" then
                    RageUI.Separator("Raison : ~g~"..raison.."")
                end 
                if montant ~= "" then 
                    RageUI.Separator("Montant : ~g~"..montant.." $")
                end
    
            end




            

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('ListeFacture', 'subBilling2'), function()
            RageUI.Separator("↓ ~b~ Facture personnel ~s~↓")

            for k,v in pairs(BillingList) do
                if v.status ~= 1 then 
                    RageUI.Button("Facture " .. v.job .. " " .. v.id, nil, {RightLabel = "→→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('billing:pay', v.id)
                            Wait (100)
                            GetBilling()
                            GetBillingJob()
                        end,
                        onActive = function()
                            RageUI.Info("Facture " .. v.id , {"Raison ", "Montant ", "Recu de ","Id de la facture", "Entreprise", "Date"}, {v.raison, v.montant .. " $", v.SenderName,v.id, v.job, v.date})
                        end
                    })
            
                end
            end 
            
            if ESX.PlayerData.job.name ~= "unemployed" then
                RageUI.Separator("↓ ~b~ Facture du job : "..ESX.PlayerData.job.label.." ~s~↓")

                RageUI.Button("Supprimer toute les facture payer" , nil, {RightLabel = ""}, true, {
                    onSelected = function()
                        PlayerJobGrade = ESX.PlayerData.job.grade_name
                        if PlayerJobGrade == "boss" then
                            ESX.ShowNotification("Vous avez supprimer toute les facture payer")
                            TriggerServerEvent('deletebilling', "all")
                        else
                            ESX.ShowNotification("Vous n'avez pas les permissions")
                        end
                    end
                })

                for k,v in pairs(BillingListJob) do
                    status = tonumber(v.status)
                    if status == 0 then   
                        status = "❌"
                    else 
                        status = "✅"
                    end
                    RageUI.Button(status .. "Facture " .. v.id, nil, {RightLabel = "→→→"}, true, {
                        onActive = function()
                            RageUI.Info("Facture " .. v.id , {"Raison ", "Montant ", "Recu de ", "Entreprise", "Payer", "Date"}, {v.raison, v.montant .. " $", v.SenderName, v.job, status, v.date})
                        end,
                        onSelected = function()
                            PlayerJobGrade = ESX.PlayerData.job.grade_name
                            if PlayerJobGrade == "boss" then
                                ESX.ShowNotification("Vous avez supprimer la facture ~g~"..v.id.."")
                                TriggerServerEvent('deletebilling', v.id)
                            else
                                ESX.ShowNotification("Vous n'avez pas les permissions")
                            end
                        end
                    })
                end
            end 

        end, function()
        end)

        Citizen.Wait(0)
    end
end)




function GetBilling()
    if playerLoaded == true then
        ESX.TriggerServerCallback('getbilling', function(billing)
            BillingList = billing
        end) 
    end
end

function GetBillingJob()
    if playerLoaded == true then
        ESX.TriggerServerCallback('getbillingjob', function(billing)
            BillingListJob = billing
        end) 
    end 
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText or "", "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        GetBilling() 
        GetBillingJob()
    end
end)

RegisterCommand("billing", function()
    OpenMenuBilling()
end)


function OpenMenuBilling()
    RageUI.Visible(RMenu:Get('Billing', 'mainBilling'), not RageUI.Visible(RMenu:Get('Billing', 'mainBilling')))
end

