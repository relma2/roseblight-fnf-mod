function pausa(missed)
    if (missed) then
        playPausa(true)
    else
        playPausa(false)
    end
    playActorAnimation('girlfriend', 'scared', true, false)
    playActorAnimation('dad', 'pausa', true, false)
end