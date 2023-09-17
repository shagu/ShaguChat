if not ShaguChat_Highlight then ShaguChat_Highlight = { "shagu" } end
if not ShaguChat_Block then ShaguChat_Block = { "cheap gold" } end
local gfind = string.gmatch or string.gfind
local popup = nil

ShaguChat_ChatFrame_OnEvent = ChatFrame_OnEvent

function ChatFrame_OnEvent(event)
  local highlight, match = "|cffffdd00", nil
  local original = arg1

  if (event == "CHAT_MSG_CHANNEL" or
    event == "CHAT_MSG_YELL" or
    event == "CHAT_MSG_SAY" or
    event == "CHAT_MSG_GUILD" or
    event == "CHAT_MSG_WHISPER") and arg2 and arg1 then

    for id, scan in pairs(ShaguChat_Highlight) do
      if strfind(string.lower(arg1), string.lower(scan)) then
        arg1 = highlight .. string.gsub(arg1, "|r", highlight)
        match = original ~= arg1 and true or match
      end
    end

    if match then
      -- add text indicators to the match
      arg1 = "|cff33ffcc!! " .. arg1 .. " |cff33ffcc!!"

      -- show popup on the errors frame
      if arg1 ~= popup then
        UIErrorsFrame:AddMessage("|r" .. arg2 .. ": " .. arg1)
        popup = arg1
      end
    end

    for id, scan in pairs(ShaguChat_Block) do
      if strfind(string.lower(arg1), string.lower(scan)) then
        return false
      end
    end
  end

  ShaguChat_ChatFrame_OnEvent(event)
end

SLASH_SHAGUCHAT1, SLASH_SHAGUCHAT2 = "/sc", "/shaguchat"
SlashCmdList["SHAGUCHAT"] = function(message)
  local commandlist = { }
  local command

  for command in gfind(message, "[^ ]+") do
    table.insert(commandlist, string.lower(command))
  end

  -- add highlight entry
  if commandlist[1] == "hl" then
    local addstring = table.concat(commandlist," ",2)
    if addstring == "" then return end
    table.insert(ShaguChat_Highlight, string.lower(addstring))
    DEFAULT_CHAT_FRAME:AddMessage("=> adding ".. addstring .." to your highlight list")

  -- add block entry
  elseif commandlist[1] == "bl" then
    local addstring = table.concat(commandlist," ",2)
    if addstring == "" then return end
    table.insert(ShaguChat_Block, string.lower(addstring))
    DEFAULT_CHAT_FRAME:AddMessage("=> adding ".. addstring .. " to your block list")

  -- remove entry
  elseif commandlist[1] == "rm" then
    if ShaguChat_Highlight[tonumber(commandlist[2])] ~= nil then
      DEFAULT_CHAT_FRAME:AddMessage("=> removing entry " .. commandlist[2]
        .. " (" .. ShaguChat_Highlight[tonumber(commandlist[2])]
        .. ") from your highlight list")

      table.remove(ShaguChat_Highlight, commandlist[2])
    elseif ShaguChat_Block[tonumber(commandlist[2] - table.getn(ShaguChat_Highlight))] ~= nil then
      DEFAULT_CHAT_FRAME:AddMessage("=> removing entry " .. commandlist[2]
        .. " (" .. ShaguChat_Block[tonumber(commandlist[2] - table.getn(ShaguChat_Highlight))]
        .. ") from your block list")

      table.remove(ShaguChat_Block, commandlist[2] - table.getn(ShaguChat_Highlight))
    end
  elseif commandlist[1] == "ls" then
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ee33Highlight:")
    local printID = 0
    for id, hl in pairs(ShaguChat_Highlight) do
      DEFAULT_CHAT_FRAME:AddMessage(" |r[|cff33ee33"..id.."|r] "..hl)
      printID = id
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cffaa3333Block:")
    for id, hl in pairs(ShaguChat_Block) do
      DEFAULT_CHAT_FRAME:AddMessage(" |r[|cffee3333"..id+printID.."|r] "..hl)
    end
  else
    DEFAULT_CHAT_FRAME:AddMessage("ShaguChat Examples:")
    DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sc hl ubrs|cffaaaaaa - |rhighlights every message containing 'ubrs'")
    DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sc bl l2p|cffaaaaaa - |rblocks every message containing 'l2p'")
    DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sc rm 3|cffaaaaaa - |rremoves entry '3' of your list")
    DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sc ls|cffaaaaaa - |rdisplays your current list")
  end
end
