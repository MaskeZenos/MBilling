ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('billing')
AddEventHandler('billing', function(tagetid , raison, montant, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tagetid)
    local TargetName = xTarget.getName()
    local PlayerName = xPlayer.getName()
    local TargetIdentifier = xTarget.identifier
    local SenderIdentifier = xPlayer.identifier
    MySQL.Async.execute('INSERT INTO MBilling (TargetIdentifier, TargetName, SenderIdentifier, SenderName, raison, montant, job) VALUES (@TargetIdentifier, @TargetName, @SenderIdentifier, @SenderName, @raison, @montant, @job)', {
        ['@TargetIdentifier'] = TargetIdentifier,
        ['@TargetName'] = TargetName,
        ['@SenderIdentifier'] = SenderIdentifier,
        ['@SenderName'] = PlayerName,
        ['@raison'] = raison,
        ['@montant'] = montant,
        ['@job'] = job
    })
    TriggerClientEvent('esx:showNotification', xTarget.source, "~r~Vous avez reçu une facture de " .. montant .. "€")
end)

RegisterNetEvent('billing:pay')
AddEventHandler('billing:pay', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    local result = MySQL.Sync.fetchAll('SELECT * FROM MBilling WHERE id = @id', {
        ['@id'] = id
    })
    if money >= result[1].montant then
        xPlayer.removeMoney(result[1].montant)
        local succes = MySQL.Sync.execute('UPDATE MBilling SET status = @status WHERE id = @id', {
            ['@status'] = 1,
            ['@id'] = id
        })
        jobdata = 'society_' .. result[1].job
        jobdata = string.lower(jobdata)
        TriggerEvent('esx_addonaccount:getSharedAccount', jobdata, function(account)
            if account ~= nil then
                account.addMoney(result[1].montant)
            end
        end)




        SenderIdentifier = result[1].SenderIdentifier
        local xTarget = ESX.GetPlayerFromIdentifier(SenderIdentifier)
        if xTarget ~= nil then
            TriggerClientEvent('esx:showNotification', xTarget.source, "~g~La facture " .. result[1].id .. " à été payé")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
    end

end)

RegisterNetEvent('deletebilling')
AddEventHandler('deletebilling', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerJobGrade = xPlayer.job.grade_name
    local PlayerJobName = xPlayer.job.name
    if id == "all" then 
        if PlayerJobGrade == "boss" then
            MySQL.Async.execute('DELETE FROM MBilling WHERE job = @job AND status = @status', {
                ['@job'] = PlayerJobName,
                ['@status'] = 1
            })
            TriggerClientEvent('esx:showNotification', source, "~g~Vous avez supprimer toutes les factures payer")
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas les permissions")
        end

    else 
        if PlayerJobGrade == "boss" then
            MySQL.Async.execute('DELETE FROM MBilling WHERE id = @id', {
                ['@id'] = id
            })
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas les permissions")
        end
    end
end)

ESX.RegisterServerCallback('getbilling', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local TargetIdentifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT * FROM MBilling WHERE TargetIdentifier = @TargetIdentifier', {
        ['@TargetIdentifier'] = TargetIdentifier
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('getbillingjob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local TargetIdentifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT * FROM MBilling WHERE job = @job', {
        ['@job'] = xPlayer.job.name
    }, function(result)
        cb(result)
    end)
end)
