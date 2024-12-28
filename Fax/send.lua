-- Function to detect modem
local function detectModem()
    for _, side in ipairs(peripheral.getNames()) do
        if peripheral.getType(side) == "modem" then
            return side
        end
    end
    return nil
end

-- Detect and open modem
local modemSide = detectModem()
if not modemSide then
    error("No modem found! Ensure a modem is connected.")
end
rednet.open(modemSide)

-- Ask for the recipient ID and message
print("Enter the recipient's ID:")
local recipientId = tonumber(read())
print("Enter your message:")
local message = read()

-- Send the message
rednet.send(recipientId, message)
print("Message sent!")
