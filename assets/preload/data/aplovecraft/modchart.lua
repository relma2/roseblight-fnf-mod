function pausa(missed)
    print("pausa enttered")
    if (missed) then
        playPausa(true)
    else
        playPausa(false)
    end
    print("sfx played")
    playActorAnimation('girlfriend', 'scared', true, false)
    playActorAnimation('dad', 'pausa', true, false)
    print("anim played")
end