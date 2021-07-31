shopReverb = 292
shopBreak = 299

myBeat = 0

shop_x = -1
shop_y = -1
trees_x = -1
trees_y = -1

function start(song)
    shop_x = getActorX("shop")
    shop_y = getActorY("shop")
    print("record shop  " .. shop_x .. ", " .. shop_y)
    trees_x = getActorX("shopbg")
    trees_y = getActorY("shopbg")
    print("record sprites  " .. trees_x .. ", " .. trees_y)
end

function beatHit(beat)
    myBeat = beat
    if (beat == shopReverb) then 
        print("begin moving camera to focus on shop window")
        tweenCameraPos(600, -200, 2.4, "nothing")  
    end
end

function nothing(camera)
end