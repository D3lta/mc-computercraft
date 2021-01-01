local config = {
    folder = "/pos/"
}

-- X = 1..15
-- Y = 1..15
-- Z = 1, 2, 3, 4
local pos = {}

function setPos(_x, _y, _z)
    pos.x = _x
    pos.y = _y
    pos.z = _z

    print("[setPos]", pos.x, pos.y, pos.z)

    storePos()

    return true
end

function getPos()
    return pos
end

function serialize(data)
    return data
end

function deserialize(data)
    return (loadstring or load)("return " .. data)()
end

function loadPos()
    local folder = config.folder

    local file = fs.open(folder .. "pos", "r")

    if not file then
        return false
    end

    local data = file.readAll()
    file.close()

    print("[Load]", data)

    data = deserialize(data)

    setPos(data.x, data.y, data.z)

    return true
end

function storePos()
    local folder = config.folder

    if not fs.isDir(folder) then
        fs.makeDir(folder)
    end

    local data = fs.open(folder .. "pos", "w")
    local position = getPos()

    -- data.write(serialize(position))
    data.write(position)
    data.close()

    return true

end

if not loadPos() then
    setPos(1, 1, 1)
end

print("[On Start]", pos.x, pos.y, pos.z)

function moveLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
end

function moveRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
end

function moveForward()
    turtle.forward()
end

function actionDig()
    turtle.digDown()
    os.sleep(0.5)
end

function actionPickUp()
    turtle.suckDown(3)
    os.sleep(0.5)
end

function actionPlant()
    turtle.select(1)
    os.sleep(0.5)
    turtle.placeDown()
end

function action()
    local found, data = turtle.inspectDown()
    if (data.state.age >= 7) then
        actionDig()
        actionPlant()
        actionPickUp()
    end
end

function move()
    if pos.y == 15 then
        if pos.x % 2 == 0 then
            moveLeft()
        else
            moveRight()
        end
    else
        moveForward()
        action()
    end
end

while pos.x < 5 do
    while pos.y <= 15 do
        os.sleep(1)

        move()

        setPos(pos.x, pos.y + 1, pos.z)
    end
    setPos(pos.x + 1, 1, pos.z)
end

setPos(1, 1, 1)
