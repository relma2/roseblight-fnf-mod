shopReverb = 292
shopBreak = 299

function beatHit(beat)
    if (beat == shopReverb) then 
        print("begin moving camera to focus on shop window")
    elseif (beat == shopReverb+1) then
        print("shake the shop sprite like realy fast")
        print("shake the \"shopbg\" sprite fast, but slightly less intense than the shop")
    elseif (beat > shopReverb + 1 and beat < shopBreak - 1) then
        print("continue shaking")
        print("continue moving camera hud to shop window focus")
    elseif (beat == shopBreak-1) then
        print("continue shaking")
	    print("finish moving camera to shop window focus")
    elseif (beat == shopBreak) then
	    -- i changed the shop prite and played the sfx in the main code
        print ("stop shaking sprites")
    else
	    -- do fucking nothing
    end
end
