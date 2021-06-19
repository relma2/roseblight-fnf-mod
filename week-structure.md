# Vs Blite Week Structure rough ideas
## Aesthetic - General changes
Desaturated Ahokau-palette assets

**NOTE:**: Because these are only aethetic/no-code changes; they can be worked on in parralell

[ ] Desaturate Boyfriend according to warm grays in ahokau.gpl
[ ] Proportion Qrystal correctly atop speakers
[ ] Green, Blue, Purple, and Red Palette Shard Arrows
[ ] Polish Backup Barble sprite

## Stage Structure (Gray):
Refer to (Aplove Tweet)[https://twitter.com/AploveStudio/status/1370435954280960004]
In Week 5, assets for the stage are layered on top of each other; including layers that "bop" - i.e, have a 4-frame simple animation.<br />
In Haxe, the stage is set up by adding and positioning these assets individualy.<br />
Refer to `art/gray_stage_mockup.mdp` to get an idea of where these assets are positioned. Art for stage itself will be worked on there
TODO: Actually do that art; position assets in "gray" stage in code

__Assets in layer order:__
1. Sky/Mountain Background (Light)
1. Top Bop: Red glow; positioned on side of mountain. Animation is the red glow bein :sparkles:*sparkly*:sparkles:
1. Layer: Trees + Fixed Window flower shop. Shop is *centered* in stage
1. Bottom Bop: Side RB characters - Clements, Zyra, Girlfriend, Crismaj? Gf is third; but looks annoyed (see song 1)
1. Two to four backup barbles

## GrayEvil:
Red glow; ppl; barbles **gone**<br />
:chains:**CHAINS EVERYWHERE**:chains: -- Refer to (Pausadina Tweet)[https://twitter.com/AploveStudio/status/1396139358621679616]

## Brain Jail
This week on BF looking for random ppl to rap battle...

Nite wants his girl on the speakers for once; chain noises; screen cuts to black; and q is on speakers with gf in background (on same layer as bg squad)
> "ah! much better"
> "beep! beep! beep!!!!11!"
> "*my* girlfriend wanted a front-row seat to the show so i was happy to oblige. isnt that right qrystal"
> (on her phone) "mhm yeah sure"
> "beep boop!"
> "Name's Blite. Saw you having a sing fest outside my flower shop so I figured I'd join in"
> "....bop"
> "Oh there's a line? Well the people back there..."
> "weren't moving forward... so I figured they were *frozen* with stage fright"
> "beep bop skedoop!"
> "well if you want her back on her spot... heh heh... you're gonna have to earn it"

### Implementaation Notes
1. Missing combo results in Nite pointing and laughing at you
	- Accomplished with Lua Modchart script (documentation here)[https://kadedev.github.io/Kade-Engine/modchart]
	- A Lua State fires on `playerOneMiss` -- is function you can implement in chart; then set `player2` (blite) animation to something like "nite laugh" using `playActorAnimation`. Make sure you add that animation from the Atlas when you initialize the character animations in Character.hx using `animation.addByPrefix`
2. At tail end of song, vocals cut and Blite puts the straps back on
	- implement in `beatHit(int beatnum)`. Because it is called every beat, you can check whether the it is the N<sup>th</sup> beat, where N is the beat number where the vocals cut. Then, change actor to blayk_idle, which is blayk but all animations are idle (implement that in Character.hx) too

### Song Motifs
Black Keys; Trowel through the BACK; Lake of Regret

**Mood**: Nite being needlessly edgy for two minutes straight; "Battle me to get yo girl back on her throne :P"

## Himbo
> "Um... hi, my name's Blite; I kind of.. own this shop so I'd like to ask that you please remove your speakers from in front of it?"
> "beep!"
> "What do you mean I already told you my nam- darn it"
> "bop boop!"
> "Not done with... our rap battle? Can I... forfeit or something?"
> "beep! beep!"

### Song Motifs
Trowel through the Heart but swing tempo; Buckler 2 main theme but swing; some original motifs

**Mood**: kind of silly trying to de-escalate? Note: Himbo is SLOWER in tempo than Brain Jail. BF starts song bc hes... in the zone??

## Aplovecraft
(shop window shatters from EPIC BASS)
> "OH COME ON!! I just had that window fixed! You-you're gonna pay for that, right?"
> "beep!!"
> "You can't just have everything contingent on a rap battle, you know."
> "...Huh? I mean... he's just a kid..."
> "..."
> "fine, but im gonna be here to prevent you from going... *overboard*"
> "admit it, you think this is fun too"
> "..."
> (they remove one shoulder strap)
> "allright, you wanna dance?"
> (Max Pausadina chains activate; chains everywhere on the stage)
> "lets dance"

### NOTE: Placeholder dialogue, not final im just trying to get a general structure\/feel i am bad at writing
### NOTE 2: Friday Night Funkin is... effectively an excuse-plot game. As long as the songs slap and the charts are fun, the "plot" can be cliche as fuck and people will still lap it up. It just needs to be coherent
---

### Implementation stuff
**Pausa notes**: Miss them and u get frozen for 3 seconds and watch helplessly as you miss more notes<br />
Consult the FNF HD mod for code on how to implement "danger notes". This is gonna be an involved implementation; save for last 

### Song Motifs:
Beyond My Understanding but key-shifted to sound more spOOkY; Blindsight theme but only a little bit; general "you are dead dead dead" third-song vibes

Voice boops have chain noises

**Mood**: *"Th-th-that's... not... an ahokan..."*
