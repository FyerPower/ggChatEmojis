-- Global Initalizations
GGCE = {}
GGCE.addonName = "ggChatEmojis"
GGCE.version   = "1.0"

local LC = LibStub("libChat-1.0")

function GGCE.Initialize( eventCode, addOnName )
  if ( addOnName ~= GGCE.addonName ) then return end

  -- Setup our chat Interceptor
  LC:registerText(function(chanID, from, text) return GGCE.Emojify(text) end )

  -- Once we've loaded ours, lets unregister the event listener
  EVENT_MANAGER:UnregisterForEvent("GGCE", EVENT_ADD_ON_LOADED)
end

function GGCE.Emojify(text)
  for key, value in pairs(GGCE.emojiGameList) do
    text = text:gsub( key, zo_iconFormat(value, 18, 18) )
  end
  return text
end

-- Hook Initialization
EVENT_MANAGER:RegisterForEvent("GGCE", EVENT_ADD_ON_LOADED , GGCE.Initialize)

-- --- --- --- --- ---
-- IDEAS
-- --- --- --- --- ---

-- Chat Cheatsheet

-- Hook into the chat system, while we type, lets give an autocomplete
-- function GGCE.ChatAutocomplete()
--   ZO_PreHookHandler(ZO_ChatWindowTextEntryEditBox, "OnEnter", function() 
--     GGCE.OutgoingChat()
--   end)
-- end








-- --- --- --- --- ---
-- Crazy Attempts
-- --- --- --- --- ---

-- Attempt: 1
-- function GGCE.ChatInterceptor()
--   local OrgOnChatEvent = CHAT_SYSTEM.OnChatEvent
--   CHAT_SYSTEM.OnChatEvent = function(control, eventCode, ...)
--     if eventCode == EVENT_CHAT_MESSAGE_CHANNEL then
--       local messageType, fromName, text = ...
--       if GGCE.supportedMessageTypes[messageType] then
--         text = GGCE.Emojify(text)
--       end
--       OrgOnChatEvent(control, eventCode, messageType, fromName, text)
--     else
--       OrgOnChatEvent(control, eventCode, ...)
--     end
--   end
-- end

-- Attempt: 2
-- function GGCE.ChatInterceptor()
--   LC = LibStub("libChat-1.0")
--   LC:registerText(function(chanID, from, text) return GGCE.Emojify(text) end )
-- end

-- Attempt: 3
-- function GGCE.ChatInterceptor()
--   local OrgOnChatEvent = CHAT_SYSTEM.OnChatEvent
--   CHAT_SYSTEM.OnChatEvent = function(control, eventCode, ...)
--     if eventCode == EVENT_CHAT_MESSAGE_CHANNEL then
--       local category = CHAT_SYSTEM:GetCategoryFromEvent(eventCode, ...)
--       d("Chat Event Triggered ("..category..")")
--       if CHAT_SYSTEM.categories[category] then
--         local formatter = ZO_ChatSystem_GetEventHandlers()[eventCode]
--         if formatter then
--           local formattedEventText, targetChannel = formatter(...)
--           if formattedEventText then
--             formattedEventText = GGCE.Emojify(formattedEventText)
--             if targetChannel then
--               CHAT_SYSTEM:HandleNewTargetOnChannel(eventCode, targetChannel, ...)
--             end
--             for container in pairs(CHAT_SYSTEM.categories[category]) do
--               GGCE.Debug:New("Chat Container", container)
--               container:OnChatEvent(eventCode, formattedEventText, category)
--             end
--           end
--         end
--       end
--     else
--       OrgOnChatEvent(control, eventCode, ...)
--     end
--   end
-- end

-- Attempt: 4
-- function GGCE.ChatInterceptor()
--   local originalCreateChatContainer = CHAT_SYSTEM.CreateChatContainer
--   CHAT_SYSTEM.CreateChatContainer = function(...)
--     local container = originalCreateChatContainer(...)
--     local onChatEvent = container.OnChatEvent
--     container.OnChatEvent = function(self, event, formattedEvent, category)
--       if(category ~= CHAT_CATEGORY_SYSTEM) then
--         formattedEvent = GGCE.Emojify(formattedEvent)
--       end
--       onChatEvent(self, event, formattedEvent, category)
--     end
--     return container
--   end
-- end
