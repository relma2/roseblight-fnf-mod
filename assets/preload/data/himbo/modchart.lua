shopReverb = 100
shopBreak = 100 + 10

function beatHit(beat)
    if (beat == shopReverb) then 
        print("begin moving camera to shop window")
    elseif (beat == shopReverb+1) then
        print("shake the shop sprite like realy fast")
    elseif (beat == shopBreak) then
	print("change shop sprite to window broken; play crash sfx")
    elseif (beat == shopBreak + 1) then
	print("begin moving camera Hud to normal position")
    else
	-- do fucking nothing
    end
end
