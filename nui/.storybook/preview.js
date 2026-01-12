// .storybook/preview.js

import { createPinia } from 'pinia';
import '../src/styles/tailwind.css';

// Add Pinia to all stories using decorators (Storybook v10+)
export const decorators = [
  (story, context) => {
    const pinia = createPinia();
    context.app.use(pinia);
    return story();
  },
];

export const parameters = {
  actions: { argTypesRegex: '^on[A-Z].*' },
};