shopReverb = 292
shopBreak = 300

function beatHit(beat)
    if (beat == shopReverb) then 
        print("begin moving camera to focus on shop window")
    elseif (beat == shopReverb+1) then
        print("shake the shop sprite like realy fast")
    elseif (beat > shopReverb + 1 and beat < shopBreak - 1) then
        print("continue moving camera hud to shop window focus")
    elseif (beat == shopBreak-1) then
	    print("finish moving camera to shop window focus")
    elseif (beat == shopBreak) then
	    print("shatter shop window by changing sprite to shop_broken\nshop stops shaking")
        print("play the shatter glass sfx")
    else
	-- do fucking nothing
    end
end
