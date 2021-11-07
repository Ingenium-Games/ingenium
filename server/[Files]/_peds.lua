local peds = {}
for k,v in pairs(conf.peds.all) do
	table.insert(peds, k)
end
c.json.Write("Peds", peds)