-- Initialize ig.garage namespace for internal runtime variables
if not ig then ig = {} end
if not ig.garage then ig.garage = {} end

-- Internal runtime variables (prefixed with _ to indicate private use)
ig.garage._TicketMachine = `prop_parkingpay`
ig.garage._MachinePosition = nil
--
-- NUI Variables
ig.garage._AtMachine = false -- within distance of machine
ig.garage._OpenMachine = false -- for in menu
ig.garage._UseMachine = false -- for animation
--
ig.garage._VehicleData = {}
ig.garage._VehicleBlip = nil
--
-- Note: ParkingSpots has been moved to conf.garage.parkingspots in _config/garage.lua
-- Note: Props table is on server-side only (ig.garage._Props in server/[Garage]/_var.lua)

-- Created entities tracking
ig.garage._CreatedEntities = {}
