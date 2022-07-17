local RealUserSettings = {
    ['Enable_Activity_Notifer'] = UserSettings['Enable_Activity_Notifer'] or true,
    ['Show_Bubble_When_Speaking'] = UserSettings['Show_Bubble_When_Speaking'] or true,
}

repeat task.wait() until game:IsLoaded()

local Notification = getrenv().require(game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("PromptCreator"))
local BubbleChatString = "BubbleChat_"..tostring(game:GetService('Players').LocalPlayer.UserId)
local ShowUIAgain = true;
game:GetService("CoreGui"):WaitForChild("BubbleChat"):WaitForChild(BubbleChatString):WaitForChild("VoiceBubble").Visible = false

game:GetService("CoreGui"):WaitForChild("BubbleChat"):WaitForChild(BubbleChatString).ChildAdded:Connect(function(Child)
    if Child.Name == 'VoiceBubble' then
        Child.Visible = false
    end
end)

function BeginCountDown()
    task.spawn(function()
        task.wait(20)
        ShowUIAgain = true
    end)
end

game:GetService("VoiceChatInternal").PlayerMicActivitySignalChange:Connect(function(Data)
    if game:GetService("CoreGui"):WaitForChild("BubbleChat"):WaitForChild(BubbleChatString):WaitForChild("VoiceBubble").RoundedFrame.Contents.Insert.Image ~= 'rbxasset://textures/ui/VoiceChat/MicDark/Muted.png' then

        if Data.isActive then
            if RealUserSettings['Show_Bubble_When_Speaking'] then
                game:GetService("CoreGui"):WaitForChild("BubbleChat"):WaitForChild(BubbleChatString):WaitForChild("VoiceBubble").Visible = true
            end
        else
            game:GetService("CoreGui"):WaitForChild("BubbleChat"):WaitForChild(BubbleChatString):WaitForChild("VoiceBubble").Visible = false
        end

        if ShowUIAgain and RealUserSettings['Enable_Activity_Notifer'] then
            Notification:CreatePrompt({
                WindowTitle = "[VoiceChat Hider]\nVoiceChat Notification",
                MainText = "ROBLOX VoiceChat is Activated\nYou can turn it off by pressing ESC and clicking the microphone button next to resume!",
                ConfirmationText = "Ok",
                CancelText = "Dont Ask Again",
                CancelActive = true,
                StripeColor = Color3.new(0.01, 0.72, 0.34),
                PromptCompletedCallback = function(Option)
                    if Option then
                        ShowUIAgain = false
                        BeginCountDown()
                    else
                        ShowUIAgain = false
                    end
                end,
            })
        end
    end
end)


