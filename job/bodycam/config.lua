Config = {}

Config.NewSharedObjectForEsx = true
Config.DevMode = true -- It must be enabled to be used when the script is restarted.
Config.WatchCoords = vector3(-318.5616, -271.8153, 35.5864)

Config.Items = {
    ["bodycam"] = "bodycam",
    ["dashcam"] = "dashcam"
}

Config.Lang = {
    -- E BUTTON TEXT
    ["e-button-text"] = "Appuez sur E du clavier",

    -- NOTIFICATIONS
    ["menu-updated"] = "Le menu a changé. Le menu est en cours de révision...",
    ["no-active-cam"] = "Aucune caméra active trouvée.",
    ["bodycam-off"] = "Caméra corporelle éteinte.",
    ["bodycam-on"] = "Caméra corporelle allumée.",
    ["dashcam-off"] = "Caméra de tableau de bord éteinte.",
    ["dashcam-on"] = "Caméra de tableau de bord allumée.",
    ["near-vehicles"] = "Vous n'êtes pas près d'un véhicule.",
    

    -- MENUS
    ["exit-cam"] = "Quitter la caméra",
    ["main-menu-title"] = "Caméras",
    ["bodycam-list"] = "Liste des caméras corporelles",
    ["bodycam-list-desc"] = "Cliquez pour voir les policiers avec une caméra corporelle active.",
    ["dashcam-list"] = "Liste des caméras de tableau de bord",
    ["dashcam-list-desc"] = "Cliquez pour voir les véhicules avec une caméra de tableau de bord.",
    
    ["watch-bodycam"] = "Regarder la caméra du policier %s",
    ["watch-dashcam"] = "Regarder la caméra de tableau de bord du policier %s",
    
}


-- TODOS
-- 1 -> When the bodycam is switched off, the recording will be archived and available for viewing.
-- 2 -> Config function to show prop on police when using bodycam
-- 3 -> Config function to show prop on police car when using dashcam