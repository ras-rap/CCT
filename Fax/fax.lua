-- Function to detect peripherals
local function detectPeripheral(type)
    for _, side in ipairs(peripheral.getNames()) do
        if peripheral.getType(side) == type then
            return side
        end
    end
    return nil
end

-- Function to wrap text
local function wrapText(text, width)
    local lines = {}
    local line = ""
    for word in text:gmatch("%S+") do
        if #line + #word + 1 > width then
            table.insert(lines, line)
            line = word
        else
            if #line > 0 then
                line = line .. " " .. word
            else
                line = word
            end
        end
    end
    if #line > 0 then
        table.insert(lines, line)
    end
    return lines
end

-- Detect peripherals
local modemSide = detectPeripheral("modem")
local printerSide = detectPeripheral("printer")

if not modemSide then
    error("No modem found! Ensure a modem is connected.")
end

if not printerSide then
    error("No printer found! Ensure a printer is connected.")
end

-- Open the modem
rednet.open(modemSide)

print("Fax machine is ready. Waiting for incoming messages...")

while true do
    -- Wait for a message
    local senderId, message, protocol = rednet.receive()

    -- Print the received message
    print("Message received from " .. senderId .. ":")
    print(message)

    -- Check if the message can be printed
    local printer = peripheral.wrap(printerSide)
    if printer and printer.getPaperLevel() > 0 then
        local width = 25  -- Maximum characters per line for the printer
        local wrappedLines = wrapText(message, width)

        printer.newPage()
        printer.write("Fax from ID: " .. senderId .. "\n")
        for _, line in ipairs(wrappedLines) do
            printer.write(line .. "\n")
        end
        printer.endPage()
        print("Message printed successfully!")
    else
        print("Cannot print message. Ensure the printer has paper.")
    end
end
