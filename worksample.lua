-- Map Setup.
local width = math.random(70, 100)
local height = math.random(30, 50)
local minRoomSize = 5
local maxRoomSize = 15
local maxRoomAttempts = 1000000
local doorChance = 0.2

-- Initialize the map.
local level = {}
for x = 1, width do
    level[x] = {}
    for y = 1, height do
        level[x][y] = "#"
    end
end

-- Generate random rooms inside the level bounds.
local rooms = {}
local firstRoom = nil
for i = 1, maxRoomAttempts do
    local room = {
        x = math.random(2, width - maxRoomSize - 1),
        y = math.random(2, height - maxRoomSize - 1),
        w = math.random(minRoomSize, maxRoomSize),
        h = math.random(minRoomSize, maxRoomSize)
    }
    local overlaps = false
    for _, other in ipairs(rooms) do
        if room.x < other.x + other.w and room.x + room.w > other.x and
           room.y < other.y + other.h and room.y + room.h > other.y then
            overlaps = true
            break
        end
    end
    -- Check that the room is fully contained within the level.
    local insideLevel = room.x > 1 and room.x + room.w < width and
                                   room.y > 1 and room.y + room.h < height
    if not overlaps and insideLevel then
        table.insert(rooms, room)
        for x = room.x, room.x + room.w - 1 do
            for y = room.y, room.y + room.h - 1 do                
                  level[x][y] = "."                
            end
        end

       
        if firstRoom == nil then
          firstRoom = room
          
    end
    
  end

  -- Spawns the player in the first generated room.
  if firstRoom ~= nil then
    local x = firstRoom.x + math.floor(firstRoom.w / 2)
    local y = firstRoom.y + math.floor(firstRoom.h / 2)
    level[x][y] = "@"
  end
end


-- creates an exit in a random location in a random room
if #rooms > 0 then
  local randomRoomIndex = math.random(#rooms)
  local randomRoom = rooms[randomRoomIndex]
  local x = randomRoom.x + math.random(randomRoom.w)
  local y = randomRoom.y + math.random(randomRoom.h)
  level[x][y] = "!"
end

-- Generate doors.
for x = 2, #level[1] - 1 do
      for y = 2, #level - 1 do
          if level[y][x] == "#" and math.random() < doorChance then
              if level[y][x-1] == "." and level[y][x+1] == "." then
                  level[y][x] = "+"
              elseif level[y-1][x] == "." and level[y+1][x] == "." then
                  level[y][x] = "+"
              end
          end
      end
  end

-- Print the map.
local mapString = ""
for y = 1, height do
    for x = 1, width do
        mapString = mapString .. level[x][y]
    end
    mapString = mapString .. "\n"
end

io.write(mapString)

