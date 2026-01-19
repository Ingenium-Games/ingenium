// Migration script to convert old jobs.json to new structure
// Run with: node scripts/migrate_jobs.js

const fs = require('fs');
const path = require('path');

const oldJobsPath = path.join(__dirname, '../data/jobs.json');
const oldJobs = JSON.parse(fs.readFileSync(oldJobsPath, 'utf8'));

// Template for new job structure
const newJobs = {};

// Default pay rates based on rank (can be customized per job)
const defaultPay = {
  1: 15,
  2: 20,
  3: 25,
  4: 30,
  5: 35
};

// Job descriptions (add more as needed)
const descriptions = {
  none: "Not currently employed",
  police: "Law enforcement agency serving the city",
  medic: "Emergency medical response and hospital services",
  pdm: "Luxury and performance vehicle dealership",
  mechanic: "Vehicle repair and customization services",
  news: "News broadcasting and journalism",
  garbage: "Waste collection and recycling services",
  pepe: "Pizza delivery and restaurant services",
  postal: "Package and mail delivery services",
  mining: "Mining and resource extraction operations",
  lumber: "Lumber harvesting and processing",
  chicken: "Poultry processing facility",
  bank: "Financial services and banking",
  city: "City government and administration",
  logistics: "Freight and logistics management",
  taxi: "Taxi and transportation services",
  // Gangs
  vargos: "Vargos street organization",
  ballers: "Ballers street organization",
  famillies: "Families street organization",
  aztecas: "Aztecas street organization",
  altruists: "Altruist cult organization",
  lostsc: "Lost Santos Chapter motorcycle club",
  marabunta: "Marabunta Grande organization",
  triads: "Triads criminal organization",
  lostmc: "Lost Motorcycle Club"
};

// Convert each job
for (const [jobName, oldGrades] of Object.entries(oldJobs)) {
  const grades = {};
  let highestRank = 0;
  
  // Convert grades
  for (const [gradeName, gradeData] of Object.entries(oldGrades)) {
    grades[gradeName] = {
      org: gradeData.org,
      rank: gradeData.rank,
      pay: defaultPay[gradeData.rank] || 15,
      isBoss: false  // Will be set below for highest rank
    };
    
    if (gradeData.rank > highestRank) {
      highestRank = gradeData.rank;
    }
  }
  
  // Mark highest rank as boss
  for (const [gradeName, gradeData] of Object.entries(grades)) {
    if (gradeData.rank === highestRank) {
      gradeData.isBoss = true;
    }
  }
  
  // Create new job structure
  newJobs[jobName] = {
    label: grades[Object.keys(grades)[0]]?.org || jobName,
    description: descriptions[jobName] || `${jobName} organization`,
    boss: null,
    grades: grades,
    members: [],
    prices: {},
    locations: {
      sales: [],
      delivery: [],
      safe: null
    },
    memos: [],
    settings: {
      showFinancials: jobName !== 'none',
      allowEmployeeActions: jobName !== 'none'
    }
  };
}

// Write new jobs.json
fs.writeFileSync(
  oldJobsPath,
  JSON.stringify(newJobs, null, 2),
  'utf8'
);

console.log('✅ Jobs.json migration complete!');
console.log(`✅ Converted ${Object.keys(newJobs).length} jobs`);
console.log('✅ New structure includes:');
console.log('   - Job labels and descriptions');
console.log('   - Boss designation (highest rank)');
console.log('   - Pay rates per grade');
console.log('   - Members array');
console.log('   - Prices object');
console.log('   - Locations (sales, delivery, safe)');
console.log('   - Memos array');
console.log('   - Settings (showFinancials, allowEmployeeActions)');
