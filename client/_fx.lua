-- Effects/graphics functions (ig.fx initialized in client/_var.lua)

function ig.fx.StartDeath()
    AnimpostfxPlay("MP_job_load", 0, true)
    AnimpostfxPlay("MP_race_crash", 0, true)
    AnimpostfxPlay("Dont_tazeme_bro", 0, true)
end

function ig.fx.StopDeath()
    AnimpostfxStop("MP_job_load")
    AnimpostfxStop("MP_race_crash")
    AnimpostfxStop("Dont_tazeme_bro")
end