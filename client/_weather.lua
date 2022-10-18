SetWeatherOwnedByNetwork(true)

--[[
Client functions
SetRainLevel(
	level 
)

local weatherType1 , weatherType2 , percentWeather2 =
	GetWeatherTypeTransition()

SetWeatherTypeTransition(
	weatherType1, 
	weatherType2 , 
	percentWeather2 
)

LoadCloudHat(
	name , 
	transitionTime 
)

The following cloudhats are useable:
altostratus
Cirrus
cirrocumulus
Clear 01
Cloudy 01
Contrails
Horizon
horizonband1
horizonband2
horizonband3
horsey
Nimbus
Puffs
RAIN
Snowy 01
Stormy 01
stratoscumulus
Stripey
shower
Wispy

]]--