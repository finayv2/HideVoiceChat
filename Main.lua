local Script = {}
local suc, err;

function Script:Init(Settings)
    local RealUserSettings = {
        ['Enable_Activity_Notifer'] = Settings['Enable_Activity_Notifer'] or true,
        ['Show_Bubble_When_Speaking'] = Settings['Show_Bubble_When_Speaking'] or true,
    }

    repeat task.wait() until game:IsLoaded()
    local VoiceChatEnabled;
    suc, err = pcall(function()
        VoiceChatEnabled = game:GetService("VoiceChatService"):IsVoiceEnabledForUserIdAsync(game:GetService('Players').LocalPlayer.UserId)
    end)

    if err or VoiceChatEnabled == nil then warn("Failed getting VoiceChatEnabled, Retrying..") Script:Init(Settings) return end
    if not VoiceChatEnabled then return end

    local Notification = getrenv().require(game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("PromptCreator"))
    local BubbleChatCore = game:GetService("CoreGui"):WaitForChild("BubbleChat")
    local BubbleChatString = "BubbleChat_"..tostring(game:GetService('Players').LocalPlayer.UserId)
    local BubbleChatCombined = game:GetService("CoreGui"):WaitForChild("BubbleChat"):WaitForChild(BubbleChatString)
    local voicebubble = BubbleChatCombined:WaitForChild("VoiceBubble")
    local ShowUIAgain = true;

    voicebubble.Visible = false
    BubbleChatCombined.ChildAdded:Connect(function(Child)
        if Child.Name == 'VoiceBubble' then
            Child.Visible = false
            voicebubble = Child
        end
    end)

    function PromptCallback(Option)
        if Option then
            ShowUIAgain = false
            task.spawn(function()
                task.wait(15)
                ShowUIAgain = true
            end)
        else
            ShowUIAgain = false
        end
    end

    game:GetService("VoiceChatInternal").PlayerMicActivitySignalChange:Connect(function(Data)
        if voicebubble.RoundedFrame.Contents.Insert.Image ~= 'rbxasset://textures/ui/VoiceChat/MicDark/Muted.png' then
            if Data.isActive then
                if RealUserSettings['Show_Bubble_When_Speaking'] then
                    voicebubble.Visible = true
                end
            else
                voicebubble.Visible = false
            end

            if ShowUIAgain and RealUserSettings['Enable_Activity_Notifer'] then
                Notification:CreatePrompt({
                    WindowTitle = "[VoiceChat Hider]\nVoiceChat Notification",
                    MainText = "ROBLOX VoiceChat is Activated\nYou can turn it off by pressing ESC and clicking the microphone button next to resume!",
                    ConfirmationText = "Ok",
                    CancelText = "Dont Ask Again",
                    CancelActive = true,
                    StripeColor = Color3.new(0.01, 0.72, 0.34),
                    PromptCompletedCallback = PromptCallback(Option)
                })
            end
        end
    end)
end

return Script

