---
--- @see RageUI
---

---@type table

local SettingsButton = {
    Text = { X = 13, Y = 10, Scale = 0.32 },
    Rectangle = { Y = 1, Width = 1, Height = 10 },
}

function RageUI.Line(R,G,B,O)
    if R == nil or G == nil or B == nil or O == nil then
        R,G,B,O = 29,144,245,255
    end
    local CurrentMenu = RageUI.CurrentMenu
    local Description = RageUI.Settings.Items.Description;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderRectangle(CurrentMenu.X + Description.Bar.Y + 60 + CurrentMenu.SubtitleHeight , CurrentMenu.Y + Description.Bar.Y + 1.9 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Description.Bar.Width - 120 + CurrentMenu.WidthOffset, Description.Bar.Height - 0.7, R, G, B, O)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height + Description.Bar.Height 
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 0
                        if (CurrentMenu.Index < 0) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 0
                    end
                end
            end
            RageUI.Options = RageUI.Options + 0
        end
    end
end