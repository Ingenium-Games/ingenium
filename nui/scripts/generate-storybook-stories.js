// scripts/generate-storybook-stories.js
import { readdirSync, statSync, existsSync, writeFileSync } from 'fs';
import { join, relative, dirname, basename } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const ROOT = join(__dirname, '..');
const SEARCH_DIR = join(ROOT, 'src');

function toTitleCase(str) {
  return str
    .replace(/\.vue$/, '')
    .split('/')
    .map(segment => segment
      .replace(/[-_]/g, ' ')
      .replace(/\b(.)/g, (m) => m.toUpperCase())
    )
    .join('/');
}

function findVueFiles(dir, fileList = []) {
  const files = readdirSync(dir);
  
  files.forEach((file) => {
    const fullPath = join(dir, file);
    const stat = statSync(fullPath);
    
    if (stat.isDirectory()) {
      findVueFiles(fullPath, fileList);
    } else if (file.endsWith('.vue')) {
      fileList.push(fullPath);
    }
  });
  
  return fileList;
}

const files = findVueFiles(SEARCH_DIR);

if (!files.length) {
  console.log('No .vue files found under src/ — nothing to generate.');
  process.exit(0);
}

files.forEach((file) => {
  const dir = dirname(file);
  const base = basename(file, '.vue');
  const storyFile = join(dir, `${base}.stories.js`);

  if (existsSync(storyFile)) {
    console.log(`Skipping existing story: ${storyFile}`);
    return;
  }

  const relImportPath = `./${base}.vue`;
  const relPath = relative(SEARCH_DIR, file);
  const title = `NUI/${toTitleCase(relPath)}`;

  const content = `import Component from '${relImportPath}';

export default { title: '${title}', component: Component };

export const Default = {
  render: () => ({
    components: { Component },
    template: '<component :is="Component" />'
  })
};
`;

  writeFileSync(storyFile, content, 'utf8');
  console.log(`Generated ${relative(ROOT, storyFile)}`);
});

console.log(`\n✓ Generated ${files.length} story files`);
