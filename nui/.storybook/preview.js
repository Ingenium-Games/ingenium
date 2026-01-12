// .storybook/preview.js

import { createPinia } from 'pinia';
import '../src/styles/tailwind.css';

// Use the new setup export for Storybook v10 Vue 3
export const setup = (app) => {
  app.use(createPinia());
};

export const parameters = {
  actions: { argTypesRegex: '^on[A-Z].*' },
};