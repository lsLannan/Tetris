-- TETRIS

-- set bg colours n empty blocks
function love.load()
    love.graphics.setBackgroundColor(255, 255, 255) -- white bg

    -- storing inert blocks
    gridXCount = 10
    gridYCount = 18

    inert = {}
    for y = 1, gridYCount do
        inert[y] = {}
        for x = 1, gridXCount do
            inert[y][x] = ' ' -- empty spaces
        end
    end

    -- set tetrominoes colours
    -- storing the tetrominoes, and their rotations 
    pieceStructures = {
        -- i 
        {
            -- horizontial 
            {
                {' ', ' ', ' ', ' '},
                {'i', 'i', 'i', 'i'},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            -- vertical
            {
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
            },
        },
        -- o, no rotations
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 'o', 'o', ' '},
                {' ', 'o', 'o', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        -- j
        {
            {
                {' ', ' ', ' ', ' '},
                {'j', 'j', 'j', ' '},
                {' ', ' ', 'j', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'j', ' ', ' '},
                {' ', 'j', ' ', ' '},
                {'j', 'j', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'j', ' ', ' ', ' '},
                {'j', 'j', 'j', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'j', 'j', ' '},
                {' ', 'j', ' ', ' '},
                {' ', 'j', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        -- l
        {
            {
                {' ', ' ', ' ', ' '},
                {'l', 'l', 'l', ' '},
                {'l', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', 'l', 'l', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', ' ', 'l', ' '},
                {'l', 'l', 'l', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'l', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        -- t 
        {
            {
                {' ', ' ', ' ', ' '},
                {'t', 't', 't', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {' ', 't', 't', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {'t', 't', 't', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {'t', 't', ' ', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        -- s
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 's', 's', ' '},
                {'s', 's', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'s', ' ', ' ', ' '},
                {'s', 's', ' ', ' '},
                {' ', 's', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        -- z
        {
            {
                {' ', ' ', ' ', ' '},
                {'z', 'z', ' ', ' '},
                {' ', 'z', 'z', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'z', ' ', ' '},
                {'z', 'z', ' ', ' '},
                {'z', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },

    }

    pieceXCount = 4
    pieceYCount = 4

    --timer = 0
    timerLimit = 0.5

    -- check in bounds returns true or false
    function canPieceMove(testX, testY, testRotation)
        for y = 1, 4 do
            for x = 1, 4 do
                local testBlockX = testX + x
                local testBlockY = testY + y

                if pieceStructures[pieceType][testRotation][y][x] ~= ' ' and (
                    testBlockX < 1
                    or testBlockX > gridXCount
                    or testBlockY > gridYCount -- check if hit bottom of grid 
                    -- check if inert
                    or inert[testBlockY][testBlockX] ~= ' '
                ) then
                    return false
                end
            end
        end
        return true 
    end
    --inert[8][5] = 'z' -- test inert block to stop movement

    function newSequence() 
        sequence = {}
        for pieceTypeIndex = 1, #pieceStructures do
            local position = love.math.random(#sequence +1)
            table.insert (
                sequence,
                position,
                pieceTypeIndex
            )
        end
    end
    --newSequence()

    function newPiece()
        pieceX = 3
        pieceY = 0
        pieceType = 1
        pieceRotation = 1
        pieceType = table.remove(sequence)

        if #sequence == 0 then
            newSequence()
        end
    end

    --game over
    function reset() 
        inert = {}
        for y = 1, gridYCount do
            inert[y] = {}
            for x = 1, gridXCount do
                inert[y][x] = ' '
            end
        end
        newSequence()
        newPiece()
        timer = 0
    end

    --newPiece()
    reset()
end

function love.update(dt)
    timer = timer + dt

    -- tetrominoes falls every .5 sec 
    if timer >= timerLimit then
        timer = 0

        local testY = pieceY + 1
        if canPieceMove(pieceX, testY, pieceRotation) then
            pieceY = testY
        else 
            for y =1, pieceYCount do
                for x=1, pieceXCount do
                    local block = 
                        pieceStructures[pieceType][pieceRotation][y][x]
                    if block ~= ' ' then 
                        inert[pieceY + y][pieceX + x] = block
                    end
                end
            end

            -- detecting full row
            for y=1, gridYCount do
                local complete = true
                for x=1, gridXCount do
                    if inert[y][x] == ' ' then
                        complete = false
                        break
                    end
                end
                -- remove the complete row
                --TODO: slow animation for row deleting
                if complete then
                    --print('Complete row: '..y)
                    --print('Clear row!')
                    for removeY = y, 2, -1 do
                        for removeX = 1, gridXCount do
                            inert[removeY][removeX] = 
                            inert[removeY-1][removeX]
                        end
                    end
                    for removeX = 1, gridXCount do
                        inert[1][removeX] = ' '
                    end
                end
            end

            -- reset to og rotation if cant move
            newPiece()

            -- Game over condition if new piece cant move 
            if not canPieceMove(pieceX, pieceY, pieceRotation) then
                love.load() -- resets game
            end
        end
        --print('tick') -- DELETE just for testing
        --pieceY = pieceY + 1
    end
end

-- user input

-- rotating tetrominoes
function love.keypressed(key)
    if key == 'x' then
        local testRotation = pieceRotation + 1
        if testRotation > #pieceStructures[pieceType] then
            testRotation = 1
        end

        if canPieceMove(pieceX, pieceY, testRotation) then
            pieceRotation = testRotation
        end


    elseif key == 'z' then
        local testRotation = pieceRotation - 1
        if testRotation < 1 then
            testRotation = #pieceStructures[pieceType]
        end

        if canPieceMove(pieceX, pieceY, testRotation) then
            pieceRotation = testRotation
        end

    elseif key == 'left' then
        local testX = pieceX-1

        if canPieceMove(testX, pieceY, pieceRotation) then
            pieceX = testX
        end

    elseif key == 'right' then 
        local testX = pieceX +1

        if canPieceMove(testX, pieceY, pieceRotation) then
            pieceX = testX
        end

    elseif key == 'c' then
        while canPieceMove(pieceX, pieceY+1, pieceRotation) do 
            pieceY = pieceY + 1 --TODO: slower fall animation?
            timer = timerLimit
    end

    -- DELETE
    elseif key == 's' then
        newSequence()
        print(table.concat(sequence, ', '))
    end
end

-- draw game grid 
function love.draw()
    local function drawBlock(block, x, y)
        -- set colours
        local colours = {
            [' '] = {.87, .87, .87}, --grey

            i = {.47, .76, .94},
            j = {.93, .91, .42},
            l = {.49, .85, .76},
            o = {.92, .69, .47},
            s = {.83, .54, .93},
            t = {.97, .58, .77},
            z = {.66, .83, .46},

            preview = {.75, .75, .75}
        }

        local colour = colours[block]
            love.graphics.setColor(colour) -- grey blocks

            local blockSize = 20
            local blockDrawSize = blockSize -1
            love.graphics.rectangle (
                'fill',
                (x-1)*blockSize,
                (y-1)*blockSize,
                blockDrawSize,
                blockDrawSize
            )
    end

    -- padding game window
    local paddingX = 2
    local paddingY = 5

    for y = 1, gridYCount do
        for x = 1, gridXCount do
            drawBlock(inert[y][x], x+paddingX, y+paddingY)

        end
    end

    -- draw piece 
    for y = 1, pieceYCount do
        for x = 1, pieceXCount do
            local block = pieceStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                -- TODO: turn into function?
                drawBlock(block, x + pieceX + paddingX, y + pieceY + paddingY)
            end
        end
    end

    for y = 1, pieceYCount do
        for x = 1, pieceXCount do
            local block = pieceStructures[sequence[#sequence]][1][y][x]
            if block ~= ' ' then
                drawBlock('preview', x+5, y+1)
            end
        end
    end

end