shopReverb = 292
shopBreak = 299

myBeat = 0

function start(song)
    shop_x = getActorX("shop")
    shop_y = getActorY("shop")
    print("record shop  " .. shop_x .. ", " .. shop_y)
end

function beatHit(beat)
    -- myBeat = beat
    -- garbage spaghetti hardcoding
    if (beat == shopReverb) then 
        print("begin moving camera to focus on shop window")
        tweenCameraPos(0, 700, 2.4, "nothing")  
    elseif (beat == shopReverb+1) then
        setActorAlpha(0.5, "girlfriend")
        tweenCameraZoom(0.75,2.0, "nothing")
    end
end

function nothing(camera)
end