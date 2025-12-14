import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [
    vue(),
    {
      name: 'rename-index',
      generateBundle(options, bundle) {
        // Safely rename index-vue.html to index.html if it exists
        const indexVueKey = Object.keys(bundle).find(key => key === 'index-vue.html')
        if (indexVueKey && bundle[indexVueKey]) {
          bundle[indexVueKey].fileName = 'index.html'
        }
      }
    }
  ],
  base: './',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    emptyOutDir: true,
    rollupOptions: {
      input: resolve(__dirname, 'index-vue.html'),
      output: {
        entryFileNames: 'assets/[name].js',
        chunkFileNames: 'assets/[name].js',
        assetFileNames: 'assets/[name].[ext]'
      }
    }
  },
  server: {
    port: 3000,
    strictPort: true
  }
})
