Config = {}

Config.StartingLocation = { x = 235.17, y = -338.18, z = 43.31, heading = 173.15 }

Config.DeliveryLocations = {
    { x = 66.03, y = -138.64, z = 55.03, heading = 205.75 },
    { x = -240.49, y = 156.17, z = 71.86, heading = 257.73 },
    { x = -595.85, y = 22.75, z = 43.26, heading = 182.47 },
    { x = -699.89, y = -186.24, z = 36.89, heading = 119.14 },
    { x = -512.41, y = 112.29, z = 63.33, heading = 8.25 },
    { x = -501.48, y = -17.39, z = 45.13, heading = 3.59 },
    { x = -603.49, y = -239.72, z = 36.56, heading = 301.66 },
    { x = -611.73, y = -391.78, z = 34.96, heading = 44.05 },
    { x = -833.25, y = -697.29, z = 27.28, heading = 30.49 },
    { x = -788.71, y = -1046.57, z = 12.42, heading = 112.37 },
    { x = -1079.97, y = -1036.67, z = 2.16, heading = 204.99 },
    { x = -1268.16, y = -886.1, z = 11.43, heading = 211.22 },
    { x = -1517.95, y = -921.18, z = 10.15, heading = 147.92 },
    { x = -1594.92, y = -278.2, z = 52.62, heading = 113.42 },
    { x = 412.97, y = 313.33, z = 103.02, heading = 207.11 },
    { x = 9.44, y = 542.25, z = 175.83, heading = 335.89 }
    -- Just added a couple here, more can easily be added :)
}


Config.BaseReward = 100
Config.DistanceMultiplier = 1.4

Config.DeliveryParking = { x = 276.19, y = -339.72, z = 44.82, heading = 66.91 }


-- UPDATE: qb-target --> init.lua
Config.Peds = {
	{
		model = 'a_m_m_business_01',
		coords = vector4(234.13, -337.83, 44.3, 163.56),
		networked = 'true',
		freeze = 'true',
		invincible = 'true',
		blockevents = 'true',
		scenario = WORLD_HUMAN_CLIPBOARD,

		target = {
			options = {
				{
					type = "client",
					event = "random:client:collectVan",
					icon = "fas fa-user-plus",
					label = "Start Job",
				}
			},
		}
	}
}