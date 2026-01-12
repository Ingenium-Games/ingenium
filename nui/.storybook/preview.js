import { createPinia, setActivePinia } from 'pinia';
import '../src/styles/tailwind.css';

// ensure this runs first
console.log('[storybook] preview.js executing - setting active Pinia');
const pinia = createPinia();
setActivePinia(pinia);
console.log('[storybook] active Pinia set:', Boolean(pinia));

// Lightweight mock for the NUI runtime used by your app components
// ...existing code...
// Replace/mock NUI more defensively (merge with any existing window.nui)
if (typeof window !== 'undefined') {
  window.__nui_listeners = window.__nui_listeners || {};

  const existing = window.nui || {};

  const send = existing.send || ((event, payload) => {
    console.log('[nui mock] send', event, payload);
    const cb = window.__nui_listeners[event];
    if (typeof cb === 'function') cb(payload);
  });

  const on = existing.on || ((event, cb) => {
    console.log('[nui mock] on', event);
    window.__nui_listeners[event] = cb;
  });

  const off = existing.off || ((event) => {
    delete window.__nui_listeners[event];
  });

  const __simulate = existing.__simulate || ((event, payload) => {
    const cb = window.__nui_listeners[event];
    if (typeof cb === 'function') cb(payload);
    else console.warn('[nui mock] no listener for', event);
  });

  // Merge back onto window.nui without clobbering other props
  window.nui = { ...existing, send, on, off, __simulate };
  console.log('[storybook] nui mock installed/merged', Boolean(window.nui.__simulate));
}
// ...existing code...
// ensure a global simulate helper that survives reassignment of window.nui
if (typeof window !== 'undefined') {
  window.__nui_listeners = window.__nui_listeners || {};

  window.__simulateNui = window.__simulateNui || ((event, payload) => {
    const cb = window.__nui_listeners[event];
    if (typeof cb === 'function') cb(payload);
    else console.warn('[nui mock] no listener for', event);
  });

  const patchNui = () => {
    window.nui = window.nui || {};
    // forward __simulate to the persistent global function
    try {
      Object.defineProperty(window.nui, '__simulate', {
        configurable: true,
        enumerable: false,
        get: () => window.__simulateNui,
      });
    } catch {
      window.nui.__simulate = window.__simulateNui;
    }

    window.nui.send = window.nui.send || ((e, p) => {
      console.log('[nui mock] send', e, p);
      const cb = window.__nui_listeners[e];
      if (typeof cb === 'function') cb(p);
    });
    window.nui.on = window.nui.on || ((e, cb) => {
      window.__nui_listeners[e] = cb;
    });
    window.nui.off = window.nui.off || ((e) => {
      delete window.__nui_listeners[e];
    });
  };

  patchNui();
  let attempts = 0;
  const iv = setInterval(() => {
    patchNui();
    attempts++;
    if (attempts > 10) clearInterval(iv);
  }, 500);
}
// ...existing code...

import { global as globalThis } from '@storybook/global';

// Single setup that registers Pinia before anything else
export const setup = (app, context) => {
  app.use(pinia);
  console.log('[storybook] app.use(pinia) called in setup');

  if (globalThis?.__TEMPLATE_COMPONENTS__?.Button) {
    app.component('GlobalButton', globalThis.__TEMPLATE_COMPONENTS__.Button);
  }

  const somePlugin = {
    install: (a, options) => {
      a.config.globalProperties.$greetingMessage = (key) => options.greetings[key];
    },
  };

  app.use(somePlugin, {
    greetings: {
      hello: `Hello Story! from some plugin your name is ${context?.name}!`,
      welcome: `Welcome Story! from some plugin your name is ${context?.name}!`,
      hi: `Hi Story! from some plugin your name is ${context?.name}!`,
    },
  });

  app.provide('someColor', 'green');
};

export const parameters = {
  actions: { argTypesRegex: '^on[A-Z].*' },
};