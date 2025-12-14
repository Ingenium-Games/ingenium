import { rename } from 'fs/promises'
import { join } from 'path'

const distPath = join(process.cwd(), 'dist')
const oldPath = join(distPath, 'index-vue.html')
const newPath = join(distPath, 'index.html')

try {
  await rename(oldPath, newPath)
  console.log('✓ Renamed index-vue.html to index.html')
} catch (error) {
  console.error('Error renaming file:', error)
  process.exit(1)
}
