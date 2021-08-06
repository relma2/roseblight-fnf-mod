shopReverb = 292
shopBreak = 299

function start(song)
    shop_x = getActorX("shop")
    shop_y = getActorY("shop")
    print("record shop  " .. shop_x .. ", " .. shop_y)
end

function beatHit(beat)
    -- garbage spaghetti hardcoding
    if (beat == shopReverb) then 
        print("begin moving camera to focus on shop window")
        tweenCameraPos(0, 50, 2.4, "nothing")  
    elseif (beat == shopReverb+1) then
        tweenCameraZoom(0.8,2.0, "holdit")
    end
end

function holdit(camera)
    setCamPosition(0, 50, 2.4)
    setCamZoom(0.8, 2.0)
end

function nothing(camera)
end