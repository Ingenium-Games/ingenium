module.exports = {
  stories: ['../src/**/*.stories.@(js|ts|mdx)'],
  framework: {
    name: '@storybook/vue3-vite',
    options: {}
  },
  addons: ['@storybook/addon-docs']
};