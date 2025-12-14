/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index-vue.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'ig-primary': '#1a1a1a',
        'ig-secondary': '#2a2a2a',
        'ig-accent': '#3a3a3a',
      }
    },
  },
  plugins: [],
}
