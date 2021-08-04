-- 16 - 29, 48 - 63, 80 - 95, 112 - 129, 132 - 133, 136 - 137, 140 - 161, 176 - 179,
-- 184 - 199, 216 - 231, 248 - 297, 312 - 315 (312 - 329 if including solo)
cut = 316
niteSings = {{17,30}, {49,64}, {81,96}, {113,130}, {133,138}, {141,162}, {177, 180}, {185,200}, {217,232}, {249, 298}, {313,329}}
singIdx = 1

prevCombo = 0
currentBeat = 0

-- So the way we are checking if the current beat is within "nite's turn"
-- is a bit more efficient than simply looping through the array niteSings
-- every single time. Instead, we call this every beat in beatHit with increment=true
-- that way, it only checks the lowest possible beat range that beat can be in,
-- and then increment the lowest possible range if the current beat has exceeded it
-- that way, the number of comparisons is however many times you called it plus
-- the number of beats in the song.
-- just something to remember for ur coding interviews
function inSingRange(beat, increment)
    if (beat >= cut) then
        return false
    end
    if (niteSings[singIdx][1] <= beat and niteSings[singIdx][2] >= beat) then
        if (increment and niteSings[singIdx][2] == beat) then
            singIdx = singIdx + 1
        end
        return true
    else
        return false
    end
end

function beatHit(beat)
    prevCombo = getProperty("combo")
    currentBeat = beat
    if (beat == cut) then 
        print("vocals cut")
        -- change dad to static blayk for remainder of song
        changeDadCharacter("blaykstatic")
        playActorAnimation("dad", "strapon", true, false)
    elseif (beat > cut) then
        -- do nothing
    else
        -- dont touch this if statement hazel
        if (inSingRange(beat, true)) then
            --print ("n sing")
        end
    end
end

function playerOneMiss(dir, conductor)
    if (prevCombo > 5 and (not inSingRange(currentBeat, false))) then
        -- POINT AND LAUGH
        prevCombo = 0
        playActorAnimation("dad", "laugh", true, false)
    end
end